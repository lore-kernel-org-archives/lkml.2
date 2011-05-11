Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1EKP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:56:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59192 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752415Ab1EKP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:56:15 -0400
Date: Wed, 11 May 2011 11:20:48 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 12/19] mfd: Use mfd cell platform_data for wm8400
 cells platform bits
Message-ID: <20110511092047.GA5487@opensource.wolfsonmicro.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
 <20110509071341.GA21967@opensource.wolfsonmicro.com>
 <20110510084500.GB17268@sortiz-mobl>
 <20110510091002.GB5146@opensource.wolfsonmicro.com>
 <20110511090318.GB2637@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511090318.GB2637@sortiz-mobl>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:03:19AM +0200, Samuel Ortiz wrote:

> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.

> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
