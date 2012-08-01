Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2HAUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:07:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39306 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2HAUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:06:58 -0400
Date: Wed, 1 Aug 2012 21:06:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [RFT][PATCH 1/5] regulator: palmas: Fix calculating selector in
 palmas_map_voltage_ldo
Message-ID: <20120801200656.GS4483@opensource.wolfsonmicro.com>
References: <1342585811.28942.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342585811.28942.3.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:30:11PM +0800, Axel Lin wrote:
> This patch fixes below issues when choosing selector:
> 
> 1. Current code returns negative selector if min_uV < 900000 which is wrong.
>    For example, it is possible to satisfy the request with selector = 1 if
>    the requested min_uV is 850000.

Applied 1-4, thanks.
