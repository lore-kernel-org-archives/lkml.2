Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2DCSqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:46:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12668 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2DCSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:46:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6669"; a="176237430"
Date: Tue, 3 Apr 2012 13:46:08 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/12] arch/hexagon: remove references to cpu_*_map.
Message-ID: <20120403184608.GA23183@codeaurora.org>
References: <1329281884.32535.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329281884.32535.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:28:04PM +1030, Rusty Russell wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> ---
>  arch/hexagon/kernel/smp.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Did I ever send a Signed-off-by for this?  I thought I did but I can't
find evidence of it.  Just in case...


Signed-off-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
