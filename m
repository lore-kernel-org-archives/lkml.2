Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2FLRKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:10:48 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:49037 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab2FLRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:10:46 -0400
Date: Tue, 12 Jun 2012 10:10:41 -0700
From: Mike Turquette <mturquette@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Constify struct clk_init_data
Message-ID: <20120612171041.GF19410@gmail.com>
References: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120514-15:12, Mark Brown wrote:
> Allow drivers to declare their clk_init_data const, the framework really
> shouldn't be modifying the data.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks for the patch Mark.  I've pulled into clk-next for testing.

Regards,
Mike
