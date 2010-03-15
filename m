Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965720Ab0COTAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:00:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:36130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680Ab0COTAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,644,1262592000"; 
   d="scan'208";a="604603049"
Date: Mon, 15 Mar 2010 19:59:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/4 v2] x86: remove rdc321x_defs.h
Message-ID: <20100315185957.GA3113@sortiz.org>
References: <201003110942.06367.florian@openwrt.org>
 <20100311105324.GA27207@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311105324.GA27207@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Mar 11, 2010 at 11:53:24AM +0100, Ingo Molnar wrote:
> 
> * Florian Fainelli <florian@openwrt.org> wrote:
> 
> > This file is going to be replaced with a cleaner version with the adding of 
> > a MFD driver for the southbridge.
> > 
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
Thanks.


> Feel free to carry it in the driver tree that ends up picking up the other 
> patches. (the MTD tree?)
The MFD tree, yes.
Florian, I'll review those patches later this week, thanks.

Cheers,
Samuel.


> Thanks,
> 
> 	Ingo

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
