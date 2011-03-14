Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1CNUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:12:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47259 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752960Ab1CNUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:12:08 -0400
Date: Mon, 14 Mar 2011 20:12:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin <wellspring3@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: milw0rm rootkit
Message-ID: <20110314201216.0b19d12b@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimE94jf0N54c5ijKUs3Ln_hhNUuCecuda98y2O9@mail.gmail.com>
References: <AANLkTim9jsGz=ELPNUVJHWN8Z4EzBrFA03XXt_QYPsEh@mail.gmail.com>
	<20110314190813.GC20259@home.goodmis.org>
	<AANLkTimE94jf0N54c5ijKUs3Ln_hhNUuCecuda98y2O9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 12:28:11 -0700
Justin <wellspring3@gmail.com> wrote:

> Yes, she runs 2.6.34.8-68.fc13.i686.PAE
> 
> I know this is for the kernel... The C file seems to exploit a
> vulnerability in the kernel, so I thought I should let the kernel
> people know so they could patch it upstream. Right? I know the hacker
> couldnt have gotten in if the security was stronger, but shouldnt the
> kernel be secured against the rootkit?

Firstly 2.6.34 is an old kernel, and we've no idea what other patches and
the like are in the Fedora version. You should ask the Fedora people
about that. Secondly the answer is no - there are various bits of user
space that are privileged and bugs in those can lead to exploitation
without the kernel being involved, particularly if you are not using
security containment setups like SELinux.

You need to talk to the distro.

Alan
