Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2DYVAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:00:49 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:56348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab2DYVAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:00:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQGAH9lmE9bdWOb/2dsb2JhbABFgx2rEYMggQeCCQEBBXgBEAsYCRYPCQMCAQIBRQYNAQcCiA+7T5BgBJV7kD6Caw
X-IronPort-AV: E=Sophos;i="4.75,483,1330902000"; 
   d="scan'208";a="981469186"
Message-ID: <4F986726.1020601@igalia.com>
Date: Wed, 25 Apr 2012 23:05:42 +0200
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: gewang@siliconmotion.com, boyod.yang@siliconmotion.com.cn,
        wuzhangjin@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: sm7xx: code improvements and cleanup
References: <1335387028-29652-1-git-send-email-jmunhoz@igalia.com> <20120425205532.GA9642@kroah.com>
In-Reply-To: <20120425205532.GA9642@kroah.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:55 PM, Greg KH wrote:
> On Wed, Apr 25, 2012 at 10:50:28PM +0200, Javier M. Mellid wrote:
>> This patch implements some code improvements and cleanup.
>>
>> New code uses dynamic debug support. Old debug calls updated/tested to
>> use this API.
>>
>> Cleanup on obsolete references, internal versions and some
>> comments. Dead code removal.
>>
>> Patch tested with SM712.
>>
>> Changes:
>>
>> - Code improvements and cleanup
>> - Use dynamic debug support
>> - Remove out-of-date comments/references
>> - Remove dead code
> 
> Can you please break this down into individual patches, each doing only
> one thing, so that we can review it easier?  Otherwise, it's quite
> difficult, which is one reason why we require patches to be created this
> way.

Yes, of course.

Thanks!

Javier
