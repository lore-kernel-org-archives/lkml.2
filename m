Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab2JEHKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:10:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48067 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2JEHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:10:22 -0400
Message-ID: <506E6EB3.7000509@monstr.eu>
Date: Fri, 05 Oct 2012 07:22:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH 01/11] net: axienet: Remove NETIF_F_SG dropping for no
 checksum feature
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu> <20121004.142612.1111166663063631532.davem@davemloft.net>
In-Reply-To: <20121004.142612.1111166663063631532.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 10/04/2012 08:26 PM, David Miller wrote:
>
> Sorry, no.
>
> I've announced on netdev very clearly that net-next submissions are not
> appropriate at this time and that only pure bug fixes should be submitted.
>
> Watch for the announcement on netdev of net-next openning up after the
> merge window closes, that's when you should resubmit this series.

Sorry I should label it as RFC.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
