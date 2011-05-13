Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab1EMQaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:30:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:4281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759041Ab1EMQaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:30:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="746888644"
Date: Fri, 13 May 2011 18:30:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv2 1/5] MFD: TPS65910: Add support for TPS65911 device
Message-ID: <20110513163013.GI8970@sortiz-mobl>
References: <A6D68D26-06DE-4FF5-ABF3-372D742F606F@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D68D26-06DE-4FF5-ABF3-372D742F606F@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Wed, May 04, 2011 at 07:21:21PM -0500, Jorge Eduardo Candelaria wrote:
> The TPS65911 is the next generation of the TPS65910 family of
> PMIC chips. It adds a few features:
> 
> - Watchdog Timer
> - PWM & LED generators
> - Comparators for system control status
> 
> It also adds a set of Interrupts and GPIOs, among other things.
> 
> The driver exports a function to identify between different
> versions of the tps65910 family, allowing other modules to
> identify the capabilities of the current chip.
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Liam, I'm ok with this one going through your tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
