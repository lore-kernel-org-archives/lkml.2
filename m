Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab2JKHMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:12:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56192 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab2JKHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:12:05 -0400
Date: Thu, 11 Oct 2012 13:50:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: Versatile Express regulator driver
Message-ID: <20121011045026.GB21451@opensource.wolfsonmicro.com>
References: <1348509414-21261-1-git-send-email-pawel.moll@arm.com>
 <1348509414-21261-2-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348509414-21261-2-git-send-email-pawel.moll@arm.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:56:54PM +0100, Pawel Moll wrote:
> Implementation of the regulator framework driver for the
> Versatile Express voltage control. Devices without
> voltage constraints (ie. "regulator-[min|max]-microvolt"
> properties in the DT node) are treated as fixed (or rather
> read-only) regulators.

Applied, thanks.
