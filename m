Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1GJCa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 22:30:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41720 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755256Ab1GJCa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 22:30:57 -0400
Date: Sun, 10 Jul 2011 11:26:01 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ambresh K <ambresh@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: TWL: Remove entry of RES_ID for 6030 macros
Message-ID: <20110710022559.GA19971@opensource.wolfsonmicro.com>
References: <1310263341-29620-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310263341-29620-1-git-send-email-ambresh@ti.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 07:02:21PM -0700, Ambresh K wrote:
> From: Ambresh K <ambresh@ti.com>
> 
> RES_ID is only used in 4030, to send PBM singular message to control
> the state of dedicated resources. In 6030, we don't have concept of PBM,
> hence removing the definition of RES_ID (num) from macros.
> 
> Signed-off-by: Ambresh K <ambresh@ti.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
