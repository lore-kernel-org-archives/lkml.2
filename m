Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2ENUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:45:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:49502 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777Ab2ENUpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152883726"
Date: Mon, 14 May 2012 22:55:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] MAX77693: add initial MAX77693 MFD driver
Message-ID: <20120514205538.GG12740@sortiz-mobl>
References: <1336995592-1505-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336995592-1505-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Mon, May 14, 2012 at 08:39:52PM +0900, Chanwoo Choi wrote:
> MAX77693 is sub PMIC(Power Management IC) working
> with other main PMIC. It has several features:
> -PMIC
> -MUIC(Micro USB Interface Controller)
> -Camera flash LED control
> -Haptic motor control
> 
> This patch adds initial basis for several devices.
> It is tested on TRATS board.
Applied both patches, thanks. And thanks to Mark for the quick review.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
