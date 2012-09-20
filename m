Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2ITS2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:28:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2ITS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:28:42 -0400
Message-ID: <505B6057.5070403@wwwdotorg.org>
Date: Thu, 20 Sep 2012 12:28:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hiroshi DOYU <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] memory: tegra{20,30}-mc: Fix reading incorrect register
 in mc_readl()
References: <1348104773.18148.2.camel@phoenix>
In-Reply-To: <1348104773.18148.2.camel@phoenix>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:32 PM, Axel Lin wrote:
> The code reading the register does not match the code writing to the register,
> fix it.
> 
> Also fix the coding style in mc_writel() for better readability.

I assume RFT==Request For Test? I haven't seen that before. Anyway,

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
