Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1GGP1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:27:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60506 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756745Ab1GGP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:26:58 -0400
Date: Thu, 7 Jul 2011 08:26:53 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] regulator: max8997: Fix setting inappropriate value for
 ramp_delay variable
Message-ID: <20110707152652.GA16325@opensource.wolfsonmicro.com>
References: <1310025116-30787-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310025116-30787-1-git-send-email-dg77.kim@samsung.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:51:56PM +0900, Donggeun Kim wrote:
> The ramp_delay variable can be set lower than the desired value.
> This patch fixes it.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
