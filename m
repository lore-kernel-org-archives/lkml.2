Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2KTJhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:37:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46226 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KTJhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:37:41 -0500
Date: Tue, 20 Nov 2012 09:35:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and
	clk_disable_unprepare()
Message-ID: <20121120093522.GM3290@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 01:22:18AM -0800, Dmitry Torokhov wrote:
> We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
> conversion so let's uninline the pair.

Again, what about stuff not using drivers/clk/clk.c ?
