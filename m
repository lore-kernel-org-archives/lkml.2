Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030851Ab2B2HgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:36:17 -0500
Received: from 017.netroom.de ([194.0.247.217]:48590 "EHLO 017.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab2B2HgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:36:16 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 02:36:16 EST
Message-ID: <4F4DD398.6080006@draisberghof.de>
Date: Wed, 29 Feb 2012 08:28:24 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: =?UTF-8?B?Ik1lbmcgWmhhbmcgKOW8oOiQjCki?= <Meng.Zhang@mediatek.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>,
        USB list <linux-usb@vger.kernel.org>,
        USB Storage list <usb-storage@lists.one-eyed-alien.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
References: <4F4C998D.4000805@mediatek.com> <Pine.LNX.4.44L0.1202281028350.1456-100000@iolanthe.rowland.org> <0D3EFCAF29FAA54FB91286E54DF1085C23048506EF@MTKMBS30.mediatek.inc> <CAA6KcBAy0iu1KU9Nc0TTB77XNth_h+4M-Uqw96nkP-ypX2jAAA@mail.gmail.com> <0D3EFCAF29FAA54FB91286E54DF1085C230485078D@MTKMBS30.mediatek.inc>
In-Reply-To: <0D3EFCAF29FAA54FB91286E54DF1085C230485078D@MTKMBS30.mediatek.inc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.02.2012 07:03, schrieb Meng Zhang:
> Thanks for your comment, I've tested some other products and found
> their entries in /lib/udev/rules.d/40-usb_modeswitch.rules. So, does
> usb_modeswitch comes with latest distributions by default?

Yes, it does. In most cases it is a prerequisite of Network Manager AFAIK.

The most-used mode switch entry in unusual_devs.h is there for 
historical reasons, from a time when usb_modeswitch was not included 
with distributions yet. I'm talking about "usb_stor_huawei_e220_init".

If people want to access the installer drive for some reason, it's not 
possible if the kernel does the mode switch without giving a choice.
With usb_modeswitch, it's a matter of a small configuration edit.

Josua Dietze
