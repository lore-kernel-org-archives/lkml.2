Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2ITWNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:13:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44762 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2ITWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:13:19 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <505B6057.5070403@wwwdotorg.org>
References: <1348104773.18148.2.camel@phoenix> <505B6057.5070403@wwwdotorg.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 21 Sep 2012 06:12:58 +0800
Message-ID: <CAF+7xWn5JiRk0-iEZ-jUfhfGwbKqpCmJ0_qVCj6uimQpbapXCA@mail.gmail.com>
Subject: Re: [PATCH RFT] memory: tegra{20,30}-mc: Fix reading incorrect
 register in mc_readl()
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hiroshi DOYU <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/21 Stephen Warren <swarren@wwwdotorg.org>:
> On 09/19/2012 07:32 PM, Axel Lin wrote:
>> The code reading the register does not match the code writing to the register,
>> fix it.
>>
>> Also fix the coding style in mc_writel() for better readability.
>
> I assume RFT==Request For Test? I haven't seen that before. Anyway,
Yes, it means "Request For Test" because I don't have a tegra platform handy.

>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks for the review and testing.

Axel
