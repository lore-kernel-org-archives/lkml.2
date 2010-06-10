Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0FJPYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:24:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:32949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0FJPYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:24:52 -0400
Message-ID: <4C1103B1.7050307@kernel.org>
Date: Thu, 10 Jun 2010 17:24:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>
Subject: Re: [PATCH] sata_sil24: Use memory barriers before issuing commands
References: <20100610145706.15588.4562.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100610145706.15588.4562.stgit@e102109-lin.cambridge.arm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 15:24:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 04:57 PM, Catalin Marinas wrote:
> The data in the cmd_block buffers may reach the main memory after the
> writel() to the device ports. This patch introduces two calls to wmb()
> to ensure the relative ordering.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Colin Tuckley <colin.tuckley@arm.com>
> Cc: Tejun Heo <tj@kernel.org>

Can you please add comments explaining why they're needed?

Thanks.

-- 
tejun
