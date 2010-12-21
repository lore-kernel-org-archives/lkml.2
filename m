Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0LUXpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:45:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25849 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0LUXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:45:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6204"; a="67788401"
Message-ID: <d141676494ae8979d4b32a337c9dba38.squirrel@www.codeaurora.org>
In-Reply-To: <20101215134107.0354c0c3@nehalam>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
    <20101215134107.0354c0c3@nehalam>
Date: Tue, 21 Dec 2010 15:44:52 -0800 (PST)
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
>> +static struct net_device_stats *rmnet_get_stats(struct net_device *dev)
>> +{
>> +	struct rmnet_private *p = netdev_priv(dev);
>> +	return &p->stats;
>> +}
>> +
>
> Just use dev->stats and this function would no longer be needed.
>
> --
>

This function will be a function pointer (ndo_get_stats) in net_device_ops
structure.

