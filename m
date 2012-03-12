Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2CLGe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:34:29 -0400
Received: from 1wt.eu ([62.212.114.60]:63150 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2CLGeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:34:22 -0400
Date: Mon, 12 Mar 2012 07:34:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
Message-ID: <20120312063412.GD8971@1wt.eu>
References: <20120312002046.282831520@1wt.eu> <1331517472.3022.150.camel@deadeye> <4F5D7D47.102@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5D7D47.102@qca.qualcomm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shafi,

On Mon, Mar 12, 2012 at 10:06:23AM +0530, Mohammed Shafi Shajakhan wrote:
> >So I'm pretty sure this patch is wrong for 2.6.32; it could be
> >backported but I don't think the change is necessary anyway.
> 
> true, but i think its better to initialize the count = 0 rather than 
> count = 1, though the older version driver checks for rate[i].idx >= 0 
> in ath_rc_tx_status. while the ath_tx_status has no such iteration in 
> the older driver code.

In practice, if the patch brings nothing and not even correctness, I'd
rather drop it than make us believe that some issue is fixed. However
if you think it does happen to fix a real issue in 2.6.32 (possibly
combined with some other missing patch), please tell me so and I will
happily undelete it.

Regards,
Willy

