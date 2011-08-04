Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1HDBSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:18:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57992 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169Ab1HDBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:18:01 -0400
Date: Thu, 4 Aug 2011 10:17:55 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] regulator: fix regulator/consumer.h kernel-doc warning
Message-ID: <20110804011753.GA10871@opensource.wolfsonmicro.com>
References: <20110803180902.4d31d143.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803180902.4d31d143.rdunlap@xenotime.net>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 06:09:02PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kernel-doc warning about internal/private data by marking it
> as "private:" so that kernel-doc will ignore it.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
