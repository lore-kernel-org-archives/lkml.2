Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0LWLvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:51:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45381 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752941Ab0LWLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:51:45 -0500
Date: Thu, 23 Dec 2010 11:51:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH] regulator MAX8998/LP3974 Bugfix: incorrect variable
 name (typo)
Message-ID: <20101223115156.GC14481@opensource.wolfsonmicro.com>
References: <1293093839-23994-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293093839-23994-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:43:59PM +0900, MyungJoo Ham wrote:
> trivial error. (buck1_idx->buck2_idx in the context of buck2 control)
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
