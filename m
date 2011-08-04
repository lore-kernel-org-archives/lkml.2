Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1HDPxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:53:04 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47227 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HDPxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:53:01 -0400
Message-ID: <4E3AC05A.1070208@gmail.com>
Date: Thu, 04 Aug 2011 10:52:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/address: Add of_iomap_nocache
References: <1312451629-28036-1-git-send-email-davidb@codeaurora.org> <20110804.031254.836213129500890372.davem@davemloft.net>
In-Reply-To: <20110804.031254.836213129500890372.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 05:12 AM, David Miller wrote:
> From: David Brown <davidb@codeaurora.org>
> Date: Thu,  4 Aug 2011 02:53:49 -0700
> 
>> Add uncached mappings from devicetree nodes similar to regular io
>> mappings.
>>
>> Signed-off-by: David Brown <davidb@codeaurora.org>
> 
> You'll need to add a sparc implementation.

Sparc just defines ioremap_nocache to ioremap, so is that really needed?

Rob
