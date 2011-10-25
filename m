Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1JYHYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:24:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48440 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723Ab1JYHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:24:17 -0400
Date: Tue, 25 Oct 2011 09:24:09 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 6/6] mfd: TPS65910: Create an array for reg init data
Message-ID: <20111025072408.GG2919@opensource.wolfsonmicro.com>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
 <1319475964-10841-7-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319475964-10841-7-git-send-email-kyle.manna@fuel7.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:06:04PM -0500, Kyle Manna wrote:
> Create an array of fixed size for the platform to pass regulator
> initalization data through.
> 
> Passing an array of pointers to init data also allows more flexible
> definition of init data as well as prevents reading past the end of the
> array should the platform define an incorrectly sized array.

Again, please make sure you use appropriate subject lines for your
patches.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
