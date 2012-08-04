Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2HDNFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 09:05:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35743 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716Ab2HDNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 09:04:52 -0400
Date: Sat, 4 Aug 2012 11:58:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: increment open_count when regulator
 supply is set
Message-ID: <20120804105846.GC10523@opensource.wolfsonmicro.com>
References: <1343055946-4205-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343055946-4205-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:35:46PM +0530, Laxman Dewangan wrote:
> When registering the regulator and setting supply for the regulator
> then increment open_count to reflect correct number of users.

Applied, thanks.
