Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2JKHLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:11:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56182 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab2JKHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:11:52 -0400
Date: Thu, 11 Oct 2012 13:50:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] regulator: core: Support for continuous voltage range
Message-ID: <20121011044954.GA21451@opensource.wolfsonmicro.com>
References: <1348509414-21261-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348509414-21261-1-git-send-email-pawel.moll@arm.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:56:53PM +0100, Pawel Moll wrote:
> Some regulators can set any voltage within the constraints range,
> not being limited to specified operating points.
> 
> This patch makes it possible to describe such regulator and makes
> the regulator_is_supported_voltage() function behave correctly.

Applied, thanks.
