Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1JBS6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:58:20 -0400
Received: from que21.charter.net ([209.225.8.22]:48618 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1JBS6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:58:10 -0400
X-Authority-Analysis: v=1.1 cv=CKBBFOpPYfBSFfEY1Rl9efxuAv/fdt7oFsWUUq3BrLQ=
 c=1 sm=1 a=yAP4_T4JbDAA:10 a=GdlGcb5RCikA:10 a=0xc6OLWX_2kA:10
 a=8nJEP1OIZ-IA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=D19gQVrFAAAA:8
 a=zEkZYiS1iPAlJyxS0wwA:9 a=eK6486TDihQfHjVOSesA:7 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E88B2AF.3020107@gregd.org>
Date: Sun, 02 Oct 2011 13:51:27 -0500
From: Greg Dietsche <greg@gregd.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 3.1-rc8 still references 2.6.42 when ioctls will be removed
References: <alpine.DEB.2.02.1110020640390.3972@p34.internal.lan> <4E889839.30005@xenotime.net> <201110021919.01918.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110021919.01918.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2011 12:19 PM, Laurent Pinchart wrote:
> Hi Randy,
>
> On Sunday 02 October 2011 18:58:33 Randy Dunlap wrote:
>> On 10/02/11 03:41, Justin Piszcz wrote:
>>> Hi,
>>>
>>> FYI--
>>>
>>> [   48.519528] uvcvideo: Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
>>> ioctls will be removed in 2.6.42.
>>>
>>> $ grep 2.6.42 -r /usr/src/linux/*
>>>
>>> /usr/src/linux/drivers/media/video/uvc/uvc_v4l2.c:                
>>> "ioctls will be removed in 2.6.42.\n");
>> Let's tell the linux-media & Laurent.
>>
>> But linux-next does not contain that line nor that function.
>> I guess something in linux-next needs to be merged into mainline.
> 2.6.42 being 3.2, I've sent a patch to remove the deprecated ioctls. Mauro has 
> applied it to his tree and will push it to Linus for v3.2.

I sent in a patch a while back that is/was meant for 3.1:
https://lkml.org/lkml/2011/7/30/75

Greg
