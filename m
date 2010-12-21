Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0LUXpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:45:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43518 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0LUXp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:45:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6204"; a="67577245"
Message-ID: <9eecc86d79182bb887f241f7367de068.squirrel@www.codeaurora.org>
In-Reply-To: <20101215134135.51df5a7f@nehalam>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
    <20101215134135.51df5a7f@nehalam>
Date: Tue, 21 Dec 2010 15:45:12 -0800 (PST)
Subject: Re: [PATCH] msm: rmnet: msm rmnet smd virtual ethernet driver
From: nvishwan@codeaurora.org
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "Niranjana Vishwanathapura" <nvishwan@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Brian Swetland" <swetland@google.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 15 Dec 2010 10:31:06 -0800
> Niranjana Vishwanathapura <nvishwan@codeaurora.org> wrote:
>
>> +
>> +static void rmnet_tx_timeout(struct net_device *dev)
>> +{
>> +	pr_info("rmnet_tx_timeout()\n");
>> +}
>
> The purpose of having a tx_timeout is to clear the pending
> request.
>
> --
>

Currently, there is no mechanism to clear the transaction.  This message
is helpful in identifying the issue and fixing it.

