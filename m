Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2GFQ5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:57:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GFQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
Date: Fri, 6 Jul 2012 23:57:44 +0700
Message-ID: <CAP_d_8WLyGPtfWY3Po4yYyg2L7EiWuWuF6X4WZ+Me6LMLwfDCQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] Input: xpad - Add a variation of Mad Catz Beat Pad
From: Yuri Khan <yurivkhan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Yuri Khan <yurivkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 11:32 PM, Yuri Khan <yurivkhan@gmail.com> wrote:

> When I add a usbhid option quirks=0x0738:0x4540:0x4 (so that usbhid does
> not attempt to handle this device) and rebuild the xpad module with the
> following patch, the device works as expected. Dmitry Torokhov, the
> current maintainer of input drivers, suggested that I include a change
> to add the usbhid quirk in my patch.

Of course the good idea only ever comes after the fact. If I change
usbhid to ignore this vendor:device unconditionally, then xpad should
also always handle it regardless of interface class/subclass/protocol,
right?
