Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0LOVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:41:40 -0500
Received: from mail.vyatta.com ([76.74.103.46]:56670 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0LOVli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:41:38 -0500
Date: Wed, 15 Dec 2010 13:41:35 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] msm: rmnet: msm rmnet smd virtual ethernet driver
Message-ID: <20101215134135.51df5a7f@nehalam>
In-Reply-To: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:31:06 -0800
Niranjana Vishwanathapura <nvishwan@codeaurora.org> wrote:

> +
> +static void rmnet_tx_timeout(struct net_device *dev)
> +{
> +	pr_info("rmnet_tx_timeout()\n");
> +}

The purpose of having a tx_timeout is to clear the pending
request.

-- 
