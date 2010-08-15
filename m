Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0HOPmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:42:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37804 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755715Ab0HOPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:42:48 -0400
Date: Sun, 15 Aug 2010 14:47:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Sundar R Iyer <sundar.iyer@stericsson.com>
Subject: Re: [PATCH] regulator: ab8500 - fix the logic to remove already
	registered regulators in error path
Message-ID: <20100815134721.GB26969@opensource.wolfsonmicro.com>
References: <1281793444.2974.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281793444.2974.5.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 09:44:04PM +0800, Axel Lin wrote:
> In current implementation, ab8500_regulator_info[0].regulator is not
> unregistered if the error happen at i > 0.
> 
> This patch fixes the resource leak and also improves the readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
