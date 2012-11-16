Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2KPEks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:40:48 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37479 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2KPEkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:40:46 -0500
Message-ID: <50A5C3CB.8040408@pobox.com>
Date: Thu, 15 Nov 2012 23:40:43 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] ata: pata_arasan: Initialize cf clock to 166MHz
References: <382d2087350ff0955ba14f125294ace4ed28382b.1352387366.git.viresh.kumar@linaro.org>
In-Reply-To: <382d2087350ff0955ba14f125294ace4ed28382b.1352387366.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 10:09 AM, Viresh Kumar wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> PATA arasan driver expects the clock to be set to 166 MHz for proper functioning.
> This patch sets clk to 166 MHz in probe.
>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/ata/pata_arasan_cf.c | 6 ++++++
>   1 file changed, 6 insertions(+)

applied



