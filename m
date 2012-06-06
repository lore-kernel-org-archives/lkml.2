Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2FFJvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:51:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47979 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab2FFJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:51:20 -0400
Date: Wed, 6 Jun 2012 10:51:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: Slightly code change for better
	readability
Message-ID: <20120606095118.GB12405@opensource.wolfsonmicro.com>
References: <1338969050.4274.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338969050.4274.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 03:50:50PM +0800, Axel Lin wrote:

> if (id == PALMAS_REG_SMPS10) {
>         do something for the case id == PALMAS_REG_SMPS10;
> } else {
>         do something for the cases id != PALMAS_REG_SMPS10;
> }

If we're going to do this a switch statement would be even better...
