Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1DZOAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:00:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:47156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1DZOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:00:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="425690222"
Date: Tue, 26 Apr 2011 16:00:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 1/4] MFD: TPS65910: Add new mfd device for TPS65910
Message-ID: <20110426140001.GA3175@sortiz-mobl>
References: <DFDB2D0D-E7B1-4E1E-A3CC-D61052D42E54@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DFDB2D0D-E7B1-4E1E-A3CC-D61052D42E54@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Thu, Apr 21, 2011 at 09:35:43AM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The TPS65910 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
The patch looks mostly good to me.
You may want to add a locked tps65910_set|clear_bits() API, since it seems
you're doing many read(reg), write(reg) sequences in the GPIO driver. That
could also be directly used by the regulator one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
