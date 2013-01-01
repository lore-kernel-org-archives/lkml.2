Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3AASdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 13:33:51 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56820 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3AASdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 13:33:50 -0500
Message-ID: <50E32C06.5020104@gmail.com>
Date: Tue, 01 Jan 2013 19:33:42 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com>
In-Reply-To: <50D62BC9.9010706@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 10:53 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 18-12-2012 21:34, Tony Prisk wrote:
>
>> Resend to include mailing lists.
>
> Such remarks should be placed under --- tear line, not in the changelog.
>
>> Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.
>
>> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
>> CC: Kyungmin Park <kyungmin.park@samsung.com>
>> CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> CC: linux-media@vger.kernel.org

I've applied first version of this patch to my tree for 3.9, thanks.
