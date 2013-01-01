Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3AATlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 14:41:13 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34715 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3AATlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 14:41:11 -0500
Message-ID: <50E33BD3.9020400@gmail.com>
Date: Tue, 01 Jan 2013 20:41:07 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 4/6] clk: s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-5-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1355852048-23188-5-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 06:34 PM, Tony Prisk wrote:
> Resend to include mailing lists.

In the future please put such comments after the --- tear line below.

> Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.
>
> Signed-off-by: Tony Prisk<linux@prisktech.co.nz>
> CC: Kyungmin Park<kyungmin.park@samsung.com>
> CC: Tomasz Stanislawski<t.stanislaws@samsung.com>
> CC: linux-media@vger.kernel.org
> ---
>   drivers/media/platform/s5p-tv/hdmi_drv.c  |   10 +++++-----
>   drivers/media/platform/s5p-tv/mixer_drv.c |   10 +++++-----
>   drivers/media/platform/s5p-tv/sdo_drv.c   |   10 +++++-----
>   3 files changed, 15 insertions(+), 15 deletions(-)

Applied, after resolving conflict with other patch that addressed
those issues in sdo_drv.c file. Thanks.
