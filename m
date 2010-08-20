Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0HTJ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:27:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0HTJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:27:37 -0400
Subject: Re: [PATCH RESEND] regulator: max8998 - fix memory allocation size
 for max8998->rdev
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <1282184959.17508.3.camel@mola>
References: <1282184959.17508.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 10:27:33 +0100
Message-ID: <1282296453.3084.33.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 10:29 +0800, Axel Lin wrote:
> We only use max8998->rdev[0] .. max8998->rdev[pdata->num_regulators-1],
> max8998->rdev[pdata->num_regulators] is not used.
> Thus fix the memory allocation size.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

