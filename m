Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2GBXdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 19:33:49 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:51646 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2GBXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 19:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <1340976992-9316-1-git-send-email-rnayak@ti.com>
References: <1340976992-9316-1-git-send-email-rnayak@ti.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 2 Jul 2012 16:33:01 -0700
Message-ID: <CAJOA=zO27M3YLSpEZRmumRhGHdQQ+Km7_CyP48UtQo6NseTG-w@mail.gmail.com>
Subject: Re: [PATCH v4] clk: Add support for rate table based dividers
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 6:36 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> Some divider clks do not have any obvious relationship
> between the divider and the value programmed in the
> register. For instance, say a value of 1 could signify divide
> by 6 and a value of 2 could signify divide by 4 etc.
> Also there are dividers where not all values possible
> based on the bitfield width are valid. For instance
> a 3 bit wide bitfield can be used to program a value
> from 0 to 7. However its possible that only 0 to 4
> are valid values.
>
> All these cases need the platform code to pass a simple
> table of divider/value tuple, so the framework knows
> the exact value to be written based on the divider
> calculation and can also do better error checking.
>
> This patch adds support for such rate table based
> dividers and as part of the support adds a new
> registration function 'clk_register_divider_table()'
> and a new macro for static definition
> 'DEFINE_CLK_DIVIDER_TABLE'.
>
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Thanks for updating this one.  I've taken it into clk-next.

Regards,
Mike
