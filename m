Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2LKKdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:33:36 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45816 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKKde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <1353533583-13166-1-git-send-email-festevam@gmail.com>
References: <1353533583-13166-1-git-send-email-festevam@gmail.com>
Date: Tue, 11 Dec 2012 08:33:34 -0200
Message-ID: <CAOMZO5BDkX2s+wK7d_KQPZbAvraM4vhcH93d_DsquTAw7tJ+vw@mail.gmail.com>
Subject: Re: [PATCH] clk: mxs: Remove unneeded NULL pointer check
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn/Mike,

On Wed, Nov 21, 2012 at 7:33 PM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> mxs platform has been converted to device tree.
>
> There is no need to check if np is NULL after doing:
>
> np = of_find_compatible_node(NULL, NULL, "fsl,imx[23/28]-clkctrl");
>
> ,as it will always be non-NULL.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Does this patch look good?
