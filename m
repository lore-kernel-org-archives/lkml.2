Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0DSIDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:03:20 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:49969 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0DSIDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=h8mmdPAradwHhGBT5e+p8zMSTvWx8q2KguoIWvRL0cGYDnAWb/EP7Upc9ECsEoi0Cu
         AA07OrfM6+o3le57eYKl4F1N6k7dhenuSwXK5dENwiom4wQ99TMD04gbHk1EZENpmpLG
         PGzlO8hRCPCVrTjAQRDHn8T2nqWtj74RcePvg=
MIME-Version: 1.0
In-Reply-To: <op.vbegell27p4s8u@pikus>
References: <cover.1271406290.git.mina86@mina86.com> <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com> 
	<7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com> 
	<41b2cd7e8bacd38bb9c997b7197e175d727876f9.1271406290.git.mina86@mina86.com> 
	<n2v8bd0f97a1004161640q640bade7xd4887dde5921b79e@mail.gmail.com> 
	<op.vbegell27p4s8u@pikus>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 19 Apr 2010 04:02:48 -0400
Message-ID: <w2v8bd0f97a1004190102pd928e442td837c8fcee0541c5@mail.gmail.com>
Subject: Re: [PATCH 3/8] USB: gadget: __init and __exit tags removed
To: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/19 Michał Nazarewicz:
> Are you referring to my previous patch by saying "then they get tweaked
> to support a semi-dynamic state"? Those were just a proposal which was never
> accepted and suggested to remove those tags all together.

i'm referring to the change that started triggering these section
mismatch warnings with 2.6.33.  i dont recall seeing any such issues
with 2.6.28-2.6.32, and probably older as well.

>> sounds like the system is insufficiently flexible to meet the
>> realistic needs of different groups.
>
> Yes, I agree.  That's why in the first version I proposed the __usb_init,
> __usb_exit, etc. tags which could be customized prior to including
> composite related files.
>
> I would still go with that solution but it was considered, let me
> find the exact phrase, "Ick ick ick." :)

seems like __usbgadget_xxx would be better naming, but i'm not
interested in fighting to get the idea in general accepted

> What's more, I don't see any other (that is cleaner) solution which
> would allow flexibility so it seems what we can either choose
> a non-flexible solution proposed by this patch or an ugly solution
> proposed by my previous patch.

i dont have a problem with your current patch (since there are still
seciton mismatch warnings floating about that i imagine this is going
to fix), just with the general situation
-mike
