Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2FLWS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:18:29 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:45331 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027Ab2FLWS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:18:28 -0400
Date: Tue, 12 Jun 2012 15:18:21 -0700
From: Mike Turquette <mturquette@ti.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Check parent for NULL in clk_change_rate
Message-ID: <20120612221821.GJ19410@gmail.com>
References: <1339160646-32664-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339160646-32664-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120608-14:04, Pawel Moll wrote:
> clk_change_rate() is accessing parent's rate without checking
> if the parent exists at all. In case of root clocks this will
> cause NULL pointer dereference.
> 
> This patch follows what clk_calc_new_rates() does in such
> situation.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Pawel,

This problem is indeed a real one.  I've taken your patch into clk-next
for testing.

Thanks much,
Mike
