Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2JJV4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:56:53 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:25481 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2JJV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:56:50 -0400
Message-ID: <5075F029.90807@laposte.net>
Date: Thu, 11 Oct 2012 00:01:13 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120826 Thunderbird/10.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ebeam PATCH v2 1/2] hid: Blacklist eBeam devices
References: <1349529287-23193-1-git-send-email-yann.cantin@laposte.net> <1349529287-23193-2-git-send-email-yann.cantin@laposte.net> <20121010163747.GD19335@core.coreip.homeip.net>
In-Reply-To: <20121010163747.GD19335@core.coreip.homeip.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 10/10/2012 18:37, Dmitry Torokhov a écrit :
> Is the device usable at all with generic HID driver? If it isn't then
> maybe we should blacklist it unconditionally?

Without the libusb based proprietary stack, the device is unusable under linux.

If i correctly understand, libusb need a driver to be present in the first place,
(even a useless generic-usb) to be able to grab the device. If we unconditionally
blacklist the device and the ebeam driver isn't loaded (not compiled for example), no way
for libusb (and the stack) to handle the device.

As stated before, i'm not comfortable with the risk of breaking other hypothetical support,
even proprietary.

-- 
Yann Cantin
A4FEB47F
--
