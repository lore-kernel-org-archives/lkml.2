Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2LRGUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:20:37 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60886 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:20:36 -0500
Message-ID: <1355811642.16857.1.camel@gitbox>
Subject: Re: [PATCH 3/4] clk: vt8500: Use of_init_clk_data()
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Dec 2012 19:20:42 +1300
In-Reply-To: <1355778135-32458-4-git-send-email-sboyd@codeaurora.org>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
	 <1355778135-32458-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 13:02 -0800, Stephen Boyd wrote:
> Reduce lines of code and simplify this driver by using the
> generic clock binding parsing function.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Tony Prisk <linux@prisktech.co.nz>
> ---
>  drivers/clk/clk-vt8500.c | 39 +++++++++++++++------------------------
>  1 file changed, 15 insertions(+), 24 deletions(-)

Looks fine, and compiles without errors/warnings.

Acked-by: Tony Prisk <linux@prisktech.co.nz>

