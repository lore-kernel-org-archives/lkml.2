Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab1EBP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:27:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:11190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1EBP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,303,1301900400"; 
   d="scan'208";a="636762733"
Date: Mon, 2 May 2011 17:27:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 1/4] MFD: TPS65910: Add new mfd device for TPS65910
Message-ID: <20110502152701.GG8222@sortiz-mobl>
References: <C3F379CD-4C84-4E7F-BD6F-078E04F15F65@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3F379CD-4C84-4E7F-BD6F-078E04F15F65@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Wed, Apr 27, 2011 at 10:51:00AM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The TPS65910 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - GPIO controller
> - RTC
> 
> The tps65910 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
I'm going to be picky here:

> +static DEFINE_MUTEX(io_mutex);
Having this mutex in the tps65910 structure would be cleaner. I know the
likeliness of having 2 of those devices in one system is very low, but still,
it would be nicer.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
