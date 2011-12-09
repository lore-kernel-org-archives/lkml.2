Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1LIQce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:32:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1496 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1LIQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:32:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6554"; a="142964315"
Date: Fri, 9 Dec 2011 10:31:46 -0600
From: Richard Kuo <rkuo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error while fetching the hexagon quilt series
Message-ID: <20111209163146.GA2506@codeaurora.org>
References: <20111209103444.64a1e274b03ac7f7bb6c54fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209103444.64a1e274b03ac7f7bb6c54fe@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 10:34:44AM +1100, Stephen Rothwell wrote:
> Hi Richard,
> 
> Fetching the hexagon quilt series produces this warning:
> 
> Read error (Success.) in headers.
> 
> And hangs for a long time ...
> 
> I am fetching from https://www.codeaurora.org/patches/quic/hlk/linux-next/
> 
> I will use what I have previously fetched.

Can a read error result from network/server issues?  Sometimes our servers
are...  not reliable.

I haven't changed that directory since the last time you fetched, so the
previous fetch will be fine.


Thanks,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
