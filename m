Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2EVU1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:27:13 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:45908 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab2EVU1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:27:10 -0400
Date: Tue, 22 May 2012 13:26:57 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: Add support for power of two type dividers
Message-ID: <20120522202657.GC4386@gmail.com>
References: <1337250134-29206-1-git-send-email-rnayak@ti.com>
 <1337250134-29206-2-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337250134-29206-2-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120517-15:52, Rajendra Nayak wrote:
> Quite often dividers and the value programmed in the
> register have a relation of 'power of two', something like
> value	div
> 0	1
> 1	2
> 2	4
> 3	8...
> 
> Add support for such dividers as part of clk-divider.
> 
> The clk-divider flag 'CLK_DIVIDER_POWER_OF_TWO' should be used
> to define such clocks.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Hi Rajendra,

This patch looks good to me.  I'll take it into my clk-next branch
towards 3.6 since I'm done pulling stuff for 3.5.

It's good to see CLK_DIVIDER_POWER_OF_TWO finally get used :-)

Regards,
Mike
