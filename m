Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1DVQdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:33:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39315 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756154Ab1DVQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:33:36 -0400
Date: Fri, 22 Apr 2011 17:34:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Samuel <chris@csamuel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Message-ID: <20110422173422.46134f20@lxorguk.ukuu.org.uk>
In-Reply-To: <201104222333.25546.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All result in the same behaviour and I'm somewhat at a loss
> as to how to debug this further, being a sysadmin rather than
> a real kernel hacker. :-(
> 
> I've attached the 2.6.39-rc4 kernel config from point 4, and
> the kernel config for the working Debian kernel (2.6.18-6-686).
> 
> I've also attached the contents of /proc/cpuinfo, /proc/io*,
> /proc/scsi/scsi, /proc/modules and the output of lspci -vvv
> and of dmesg from Debian Sarge running the Debian Etch kernel
> (2.6.18-6-686).
> 
> This box has given me good service over the past 8 years or
> so and I'd hate to have to retire it now due to this when I
> feel Linux should still work on it..
> 
> Any ideas please ?

earlyprintk=vga

(or better yet earlyprintk=ttyS0 and a serial port)

There are a couple of PPro funnies - there's an area of memory that
must be excluded due to a chip errata and I seem to remember some PPro
boxes also having slightly quirking E820 (BIOS memory reporting behaviour)


Alan
