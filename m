Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1KHP4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:56:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37485 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab1KHP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:56:42 -0500
Date: Tue, 8 Nov 2011 15:56:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH RESEND v2 2/2] regulator: TPS65910: VDD1/2 voltage
 selector count
Message-ID: <20111108155639.GE5632@opensource.wolfsonmicro.com>
References: <1320758650-29180-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320758650-29180-1-git-send-email-afzal@ti.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:54:10PM +0530, Afzal Mohammed wrote:
> Count of selector voltage is required for regulator_set_voltage
> to work via set_voltage_sel. VDD1/2 currently have it as zero,
> so regulator_set_voltage won't work for VDD1/2.
> Update count (n_voltages) for VDD1/2.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
