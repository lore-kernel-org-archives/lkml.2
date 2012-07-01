Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2GAUkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:40:51 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:41947 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2GAUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:40:29 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2012 16:40:29 EDT
From: Romain Francoise <romain@orebokech.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Organization: orebokech dot com
References: <20120628131651.GA14492@gherkin.frus.com>
	<CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
	<20120629033600.GA3591@gherkin.frus.com>
	<20120630033519.GA4792@kroah.com>
	<20120701201411.GB8603@gherkin.frus.com>
X-Face: }9mYu,e_@+e!`Z-P5kVXa3\_b:hdJ"B)ww[&=b<2=awG:GOIM</2q'*t@MNa)R`k0h1KbUu "Ek%gXCQA(?k=Uf9}qgF_x#7/+Ql\R!NJ9[Z[ky\CTYI<H(kc][?[m%*rsf!OG11|f&H[VgX;),"!N JG6IziY\~""3M
Date: Sun, 01 Jul 2012 22:34:08 +0200
In-Reply-To: <20120701201411.GB8603@gherkin.frus.com> (Bob Tracy's message of
	"Sun, 1 Jul 2012 15:14:11 -0500")
Message-ID: <87hatrjk5b.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy <rct@gherkin.frus.com> writes:

> Per the syslog entries I included in my initial post on this thread, the
> only difference between the pre- and post- usbfs removal cases seems to
> be whatever is needed for the input subsystem to see the USB keyboard
> and mouse.  I see the USB hubs and attached devices getting detected,
> but whatever "glue" allows the keyboard and mouse to work isn't there,
> and the input subsystem doesn't emit the expected messages at boot time.

FWIW, I have a similar issue on one of my boxes, v3.5-rc doesn't seem to
register the keyboard as an input device at boot time, using an initrd
with udev (175). The USB devices are detected, I can see usbhid getting
loaded, but the keyboard just doesn't work. And on this box the root
filesystem is luks-encrypted, which makes debugging somewhat difficult
without a keyboard.

The same keyboard works with the same kernel image on another box, so I
have no idea what this is about.
