Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2GAU6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:58:38 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:41960 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2GAU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:58:37 -0400
From: Romain Francoise <romain@orebokech.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        "Henrik Rydberg" <rydberg@euromail.se>, linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Organization: orebokech dot com
References: <20120628131651.GA14492@gherkin.frus.com>
	<CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
	<20120629033600.GA3591@gherkin.frus.com>
	<20120630033519.GA4792@kroah.com>
	<20120701201411.GB8603@gherkin.frus.com>
	<87hatrjk5b.fsf@silenus.orebokech.com>
X-Face: }9mYu,e_@+e!`Z-P5kVXa3\_b:hdJ"B)ww[&=b<2=awG:GOIM</2q'*t@MNa)R`k0h1KbUu "Ek%gXCQA(?k=Uf9}qgF_x#7/+Ql\R!NJ9[Z[ky\CTYI<H(kc][?[m%*rsf!OG11|f&H[VgX;),"!N JG6IziY\~""3M
Date: Sun, 01 Jul 2012 22:58:35 +0200
In-Reply-To: <87hatrjk5b.fsf@silenus.orebokech.com> (Romain Francoise's
	message of "Sun, 01 Jul 2012 22:34:08 +0200")
Message-ID: <87r4svb3lw.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> FWIW, I have a similar issue on one of my boxes, v3.5-rc doesn't seem to
> register the keyboard as an input device at boot time, using an initrd
> with udev (175).

Ah, duh. My initrd scripts (Debian's initramfs-tools 0.106) don't include
the new hid-generic module in the initramfs... adding it manually fixes
the problem. Thanks Henrik!
