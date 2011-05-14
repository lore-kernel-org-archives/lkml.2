Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab1ENQMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:12:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42609 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752961Ab1ENQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:12:47 -0400
Date: Sat, 14 May 2011 09:12:44 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk
Subject: Re: [PATCH v2 3/4] REGULATOR: TWL6025: add support to twl-regulator
Message-ID: <20110514161243.GE2791@opensource.wolfsonmicro.com>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
 <1305206878-18094-4-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305206878-18094-4-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:27:57PM +0100, Graeme Gregory wrote:
> Adding support for the twl6025. Major difference in the twl6025 is the
> group functionality has been removed from the chip so this affects how
> regulators are enabled and disabled.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
