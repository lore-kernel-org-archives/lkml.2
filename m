Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1K1Ltj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:49:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55132 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1K1Lti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:49:38 -0500
Date: Mon, 28 Nov 2011 11:49:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Convert virtual and userspace regulator
 consumer drivers to use module_platform_driver()
Message-ID: <20111128114935.GC8275@opensource.wolfsonmicro.com>
References: <1322451519.24694.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322451519.24694.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:38:39AM +0800, Axel Lin wrote:
> This patch converts virtual and userspace regulator consumer drivers to use the
> module_platform_driver() macro which makes the code smaller and a bit simpler.

Applied, thanks.
