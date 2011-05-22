Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1EVUnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:43:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:55403 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1EVUnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:43:10 -0400
X-ExtLoop1: 1
Date: Sun, 22 May 2011 22:43:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: [PATCH] mfd: Fix ASIC3 SD Host Controller Configuration size
Message-ID: <20110522204306.GI18610@sortiz-mobl>
References: <E1QLc4H-0005Vx-7y@outmx05.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QLc4H-0005Vx-7y@outmx05.plus.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, May 15, 2011 at 02:13:11PM +0000, Paul Parsons wrote:
> The size of the TC6380AF SD Host Controller Configuration area is 0x200 bytes (assuming registers are aligned on 32-bit boundaries), not 0x400 bytes. Source: Toshiba TC6380AF Specification sections 4.2 and 4.3.1
> 
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
