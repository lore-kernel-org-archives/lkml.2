Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1L2KoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:44:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53254 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab1L2KoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:44:20 -0500
Date: Thu, 29 Dec 2011 10:44:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Fix the error handling if
 create_regulator fails
Message-ID: <20111229104416.GE2909@opensource.wolfsonmicro.com>
References: <1325149328.7012.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325149328.7012.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 05:02:08PM +0800, Axel Lin wrote:
> In the case of create_regulator() fails, goto the error path immediately.
> It does not make sense to update rdev->open_count if create_regulator fails.

Applied both, thanks.
