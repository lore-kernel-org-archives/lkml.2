Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1HDMme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:42:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35542 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1HDMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:42:30 -0400
Date: Thu, 4 Aug 2011 13:42:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dahuang@nvidia.com
Cc: lrg@ti.com, mike@compulab.co.il, sameo@linux.intel.com, xxie@nvidia.com,
        gking@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting
Message-ID: <20110804124220.GA14921@sirena.org.uk>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
X-Cookie: Ignore previous fortune.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:34:22PM +0800, dahuang@nvidia.com wrote:
> From: Danny Huang <dahuang@nvidia.com>
> 
> Add output vlotage slew rate setting for SM0/SM1

Oh, and you should also be implementing set_voltage_time_sel() if you
know what the slew rate for the device is.
