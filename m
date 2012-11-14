Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab2KNRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:12:38 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52717 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422781Ab2KNRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:12:37 -0500
Date: Wed, 14 Nov 2012 17:17:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Forconi <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
Message-ID: <20121114171755.27b8423b@pyramind.ukuu.org.uk>
In-Reply-To: <624976355.1341772.1352911727159.JavaMail.root@zmail.sgconsulting.it>
References: <20121114115255.2dfaefc9@pyramind.ukuu.org.uk>
	<624976355.1341772.1352911727159.JavaMail.root@zmail.sgconsulting.it>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This backlight problem appears only when I run linux with KMS framebuffer,
> when I run linux without KMS framebuffer, the backlight is always on.
> 
> Yes, I have ACPI enabled and ACPI backlight enabled, but running:
> echo 100 > /sys/class/backlight/psb-bl/brightness

psb-bl/backlight willbe the backlight of the graphics not the ACPI
driver. You may need to enable that and also hack the acpi_video code to
add it anyway on that device.

> But, in the end, this means that the driver si correctly loaded and the 
> framebuffer is running but the panel backlight is off?
> In other words, I can't see anything only because the backlight is off?

I think so.

> I don't know which could be the maximum value, there are any standard values
> for backlight settings? I could try setting some values and see what happens...

Unfortunately not - and I have no idea what overdriving it would do to
the hardware.

Alan
