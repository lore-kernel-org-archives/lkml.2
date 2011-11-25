Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1KYE3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 23:29:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39815 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1KYE3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 23:29:03 -0500
MIME-Version: 1.0
In-Reply-To: <CACVxJT8D_9T+N8siZBGMccjUTeyip5YxNPg_jFTjpE4Bwb+CLA@mail.gmail.com>
References: <CA+NV+Vkog3M6BMC9iMAdCJPbsDQUvPJx1ucsX5FV=kHJLu+ryw@mail.gmail.com>
 <CACVxJT8D_9T+N8siZBGMccjUTeyip5YxNPg_jFTjpE4Bwb+CLA@mail.gmail.com>
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Fri, 25 Nov 2011 09:58:42 +0530
Message-ID: <CA+NV+Vn7y7VNwuFueM2JeoXiA1azE_8pyAZwHi-M1EB0X-aBZg@mail.gmail.com>
Subject: Re: [path] adding header info in raw.h
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 9:44 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Nov 24, 2011 at 1:09 PM, Rahul Bedarkar <rpal143@gmail.com> wrote:
>> --- a/include/linux/raw.h
>> +++ b/include/linux/raw.h
>> @@ -1,3 +1,9 @@
>> +/*
>> +* include/linux/raw.h
>> +*
>> +* include file for raw block device drivers
>> +*/
>
> Quite a useless comment.
> Filename inside file especially.
>
I have seen File name inside file rbtree.h, it is 19th line in my repo.

Regards,
Rahul Bedarkar
