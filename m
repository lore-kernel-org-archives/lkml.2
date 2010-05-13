Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0EMJkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:40:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44232 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167Ab0EMJkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:40:14 -0400
Date: Thu, 13 May 2010 10:40:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mattias Wallin <mattias.wallin@stericsson.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] Regulators: ab3100/bq24022: add a missing .owner field
	in regulator_desc
Message-ID: <20100513094012.GA21623@opensource.wolfsonmicro.com>
References: <1273743181.10563.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273743181.10563.4.camel@mola>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 05:33:01PM +0800, Axel Lin wrote:
> This patch adds a missing .owner field in regulator_desc, which is used for refcounting.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
