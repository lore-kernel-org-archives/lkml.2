Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab0HRHRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:17:02 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:38735 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0HRHQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:16:59 -0400
Date: Wed, 18 Aug 2010 10:16:19 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>
Cc: "ext Gopinath, Thara" <thara@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Message-ID: <20100818071619.GE11947@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB032422229C@dbde02.ent.ti.com>
 <20100818065905.GC11947@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03242222C7@dbde02.ent.ti.com>
 <20100818071022.GD11947@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100818071022.GD11947@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 18, 2010 at 09:10:22AM +0200, Balbi Felipe (Nokia-MS/Helsinki) wrote:
>On Wed, Aug 18, 2010 at 09:03:44AM +0200, ext Gopinath, Thara wrote:
>>>>No I am not talking about the key values. I was talking about the register offset
>>>>for TWL4030_PM_MASTER_PROTECT_KEY. My question is, is it ok for it to be 0xd or 0xe.
>>>>Earlier we were using 0xd and in the new implementation it has been changed to 0xe.
>>
>>Typo. Earlier we were using 0xe and in the new implementation it has
>>been changed to 0xd.
>
>you're right, I'm not sure how I came up with that value since the TRM
>shows 0x0e, maybe a copy&paste error. Will change patch 1.

ok, it's because there's no register 0x0a. And I missed that when 
defined the register space. Good catch, thanks. I wonder why it didn't 
fail to write to that register address :-?

-- 
balbi

DefectiveByDesign.org
