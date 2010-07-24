Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0GXPc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:32:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0GXPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:32:27 -0400
Message-ID: <4C4B07A6.4050009@infradead.org>
Date: Sat, 24 Jul 2010 12:32:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
References: <20100706175332.952fec90.sfr@canb.auug.org.au> <20100707151355.GB2121@kroah.com> <4C3C876A.5090005@infradead.org> <201007131923.31877.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007131923.31877.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-07-2010 14:23, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Tuesday 13 July 2010 17:34:02 Mauro Carvalho Chehab wrote:
>> Em 07-07-2010 12:13, Greg KH escreveu:
>>> On Tue, Jul 06, 2010 at 09:34:51AM -0300, Mauro Carvalho Chehab wrote:
>>>> Em 06-07-2010 08:10, Laurent Pinchart escreveu:
> 
> [snip]
> 
>>>>> Mauro, can the uvc-gadget patches go through the linux-media tree ?
>>
>> It will not be simple to fix this conflict from my tree. I tried to apply
>> them against a 2.6.35-rc5, but it failed:
>> |diff --git a/drivers/media/video/uvc/uvcvideo.h
>> |b/drivers/media/video/uvc/uvcvideo.h index 47b20e7..ac27245 100644
>> |--- a/drivers/media/video/uvc/uvcvideo.h
>> |+++ b/drivers/media/video/uvc/uvcvideo.h
>>
>> --------------------------
>> No file to patch.  Skipping patch.
>> 1 out of 1 hunk ignored
>> can't find file to patch at input line 73
>> Perhaps you used the wrong -p or --strip option?
> 
> drivers/media/video/uvc/uvcvideo.h has been there for years. Perhaps you used 
> the wrong -p or --strip option? :-)

Doubtful. My scripts apply the patches using -p1. Not sure what happened.

> [snip]
> 
>>>>> Patch
>>>>> patches/lmml_111238_for_2_6_36_uvc_move_constants_and_structures_defin
>>>>> itions_to_linux_usb_video_h.patch doesn't apply
>>
>> It seems that the files you're patching at include/linux/usb & cia are not
>> upstream yet. So, just adding this patch won't solve it.
>>
>>>> If Greg is ok, that's fine for me.
>>>
>>> That's fine with me.  Let me know when you have them and then I'll drop
>>> them from my tree.
>>
>> I'll be out for vacations for some days. Greg/Laurent, it seems that the
>> better is to keep Stephen workaround for now, eventually applying it at
>> Greg's tree.
> 
> If it's not too late, can you retry with the right -p option ?
> 
It were too late... I just returned from vacations, and started to dig my long
list of emails...

Could you please re-send the patch, being sure that it will apply against a
-rc kernel?

Cheers,
Mauro
