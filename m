Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0J0UZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:25:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51276 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab0J0UZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mFsO7HDTDxoqUx8U++83XVlOyN3zx6Pr/FPBY/VfJpYBt0d/xqiLhJf+B2BgqIYVHV
         3xDPQYXoP/EXLD8wwGmDCAhbDRbQk6jU2t0g4sIo2eWcqtEHj1llnbGzSvXEUP03T1t5
         W5mRjzzoD+kmqVqVT2bnb7hTiO8ixE4Oa2eWE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
Date: Wed, 27 Oct 2010 13:25:34 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.4.5; x86_64; ; )
Cc: Tom Vier <tom@triadsys.com>, Samuel Thibault <sthibault@debian.org>,
        "594089@bugs.debian.org" <594089@bugs.debian.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
References: <20101025180320.GA4725@const.famille.thibault.fr> <20101027192508.GA29761@core.coreip.homeip.net> <0D753D10438DA54287A00B027084269764819C63F4@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B027084269764819C63F4@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010271325.37935.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 27, 2010 01:20:09 pm H Hartley Sweeten wrote:
> Wednesday, October 27, 2010 12:25 PM, Dmitry Torokhov wrote:
> >> I: Bus=0003 Vendor=046d Product=c30a Version=0110
> >> N: Name="Logitech Logitech USB Keyboard"
> >> P: Phys=usb-0000:00:13.0-2/input0
> >> S: Sysfs=/devices/pci0000:00/0000:00:13.0/usb5/5-2/5-2:1.0/input/input9
> >> U: Uniq=
> >> H: Handlers=kbd event2
> >> B: EV=120013
> >> B: KEY=1000000000007 ff800000000007ff febeffdfffefffff fffffffffffffffe
> >> B: MSC=10
> >> B: LED=1f
> >> 
> >> I: Bus=0003 Vendor=046d Product=c30a Version=0110
> >> N: Name="Logitech Logitech USB Keyboard"
> >> P: Phys=usb-0000:00:13.0-2/input1
> >> S: Sysfs=/devices/pci0000:00/0000:00:13.0/usb5/5-2/5-2:1.1/input/input10
> >> U: Uniq=
> >> H: Handlers=kbd mouse2 event3
> >> B: EV=17
> >> B: KEY=fffffffffffff f8403340000 60d8fafd01d008 1f000000000000 0
> >> B: REL=103
> >> B: MSC=10
> > 
> > Hmm, this keyboard registers 2 input devices... I wonder, if you press
> > CapsLock/Favories and RightShift/Previous and monitor both event devices
> > with evtest - will it report events on both devices at once?
> 
> I haven't really been following this thread but I think the two input
> devices is normal if the keyboard has multi-media keys.  All the "extra"
> keys show up as a separate input device.
> 
> You might get the CapsLock and RightShift events on one device and the
> Favorites and Previous events on the other.

It is normal on sane devices however in this case there are "ghost"
key presses coming from an unknown source.


-- 
Dmitry
