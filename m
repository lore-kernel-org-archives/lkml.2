Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2LVVxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 16:53:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39335 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2LVVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 16:53:29 -0500
Message-ID: <50D62BC9.9010706@mvista.com>
Date: Sun, 23 Dec 2012 01:53:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1355852048-23188-7-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-12-2012 21:34, Tony Prisk wrote:

> Resend to include mailing lists.

    Such remarks should be placed under --- tear line, not in the changelog.

> Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
> CC: linux-media@vger.kernel.org

WBR, Sergei


