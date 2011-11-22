Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1KVOPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:15:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47669 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1KVOPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111122124357.GA32440@gamma.logic.tuwien.ac.at>
References: <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com>
	<20111121030640.GI32505@gamma.logic.tuwien.ac.at>
	<CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
	<20111122051310.GA23705@gamma.logic.tuwien.ac.at>
	<CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com>
	<CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
	<20111122072730.GA32225@gamma.logic.tuwien.ac.at>
	<CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com>
	<2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at>
	<CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
	<20111122124357.GA32440@gamma.logic.tuwien.ac.at>
Date: Tue, 22 Nov 2011 16:15:20 +0200
Message-ID: <CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 14:43, Norbert Preining <preining@logic.at> wrote:
> On Di, 22 Nov 2011, Emmanuel Grumbach wrote:
>> Sorry, please try again with that one.
>
> Here we go:
>
> [   48.355300] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [   48.360704] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [   48.402330] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
> [   48.403914] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
> [   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
> [   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
> [   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
> [   48.484466] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [   48.488913] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [   48.534317] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
> [   48.535806] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
> [   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
> [   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
> [   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
> [   56.273961] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
> [   56.276374] wlan0: authenticated
> [   56.281516] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
> [   56.288627] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
> [   56.288633] wlan0: associated
> [   74.164324] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
> [   75.164059] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
> [   75.165912] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [   76.481181] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 1
> [   76.482944] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0

This is completely broken. This log looks really bad. AGG are enabled
and disabled right away, messing the queues completely.
It looks like the AGG gets disabled in the between alloc and status.
Will send another patch later.

Thanks
