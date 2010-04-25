Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab0DYP0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0DYP0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:26:35 -0400
Message-ID: <4BD45F20.9040901@redhat.com>
Date: Sun, 25 Apr 2010 12:26:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/2] media, mfd: Add timberdale video-in driver
References: <1271435274.11641.44.camel@debian> <20100416171335.GC28863@sortiz.org>
In-Reply-To: <20100416171335.GC28863@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz wrote:
> Hi Richard,
> 
> On Fri, Apr 16, 2010 at 06:27:54PM +0200, Richard Röjfors wrote:
>> To follow are two patches.
>>
>> The first one adds the timberdale video-in driver to the media tree.
>>
>> The second one adds it to the timberdale MFD driver.
>>
>> The Kconfig of the media patch selects TIMB_DMA which is introduced
>> in the DMA tree, that's why I cc:d in Dan.
>>
>> Samuel and Mauro hope you can support and solve the potential merge
>> issue between your two trees.
> Mauro, the mfd part of this patch depends on the video one. Do you mind if I
> take both through my tree, after getting your Acked-by ?

No problem. I'll let you know after I get my ack.


-- 

Cheers,
Mauro
