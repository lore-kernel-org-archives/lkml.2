Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HRHLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:11:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18406 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab0HRHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:11:17 -0400
Date: Wed, 18 Aug 2010 10:10:22 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext Gopinath, Thara" <thara@ti.com>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Message-ID: <20100818071022.GD11947@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB032422229C@dbde02.ent.ti.com>
 <20100818065905.GC11947@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03242222C7@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03242222C7@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Aug 2010 07:10:31.0201 (UTC) FILETIME=[719F3910:01CB3EA4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 18, 2010 at 09:03:44AM +0200, ext Gopinath, Thara wrote:
>>>No I am not talking about the key values. I was talking about the register offset
>>>for TWL4030_PM_MASTER_PROTECT_KEY. My question is, is it ok for it to be 0xd or 0xe.
>>>Earlier we were using 0xd and in the new implementation it has been changed to 0xe.
>
>Typo. Earlier we were using 0xe and in the new implementation it has 
>been changed to 0xd.

you're right, I'm not sure how I came up with that value since the TRM 
shows 0x0e, maybe a copy&paste error. Will change patch 1.

-- 
balbi

DefectiveByDesign.org
