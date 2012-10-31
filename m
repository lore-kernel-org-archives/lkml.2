Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2JaRMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:12:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33446 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab2JaRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:12:34 -0400
Date: Wed, 31 Oct 2012 17:17:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Shea Levy <shea@shealevy.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031171733.0ff2a976@pyramind.ukuu.org.uk>
In-Reply-To: <50915975.8030503@shealevy.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
	<20121031170334.59833fb1@pyramind.ukuu.org.uk>
	<50915975.8030503@shealevy.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Prepare (as a root) a hand-crafted image, reboot, let the kernel resume
> >> from that artificial image.
> > It's not signed. It won't reboot from that image.
> 
> So then to hibernate the kernel must have a signing key?

No.

If you break the kernel so you can patch swap we already lost.

If you add a new bootable image and reboot your image won't boot anyway

If you've got physical access you've already won

So you can't break the swap image before hibernation. You can't boot
something else to tamper with it and you've not got physical access.
