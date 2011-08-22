Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1HVOVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:21:25 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:1266 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab1HVOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:21:21 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Aug 2011 10:21:20 EDT
X-IronPort-AV: E=Sophos;i="4.68,263,1312149600"; 
   d="scan'208";a="106045475"
Message-ID: <4E52638C.8080407@inria.fr>
Date: Mon, 22 Aug 2011 16:11:24 +0200
From: Pierre Louis Aublin <pierre-louis.aublin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Bing Zhao <bzhao@marvell.com>, kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/net/wireless/mwifiex/scan.c: test the just-initialized
 value
References: <1314021636-11528-4-git-send-email-julia@diku.dk>
In-Reply-To: <1314021636-11528-4-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

On 08/22/2011 04:00 PM, Julia Lawall wrote:
> -	if (!bss_desc) {
> +	if (!beacon_ie) {
>   		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
Shouldn't we also modify the error message, from "failed to alloc 
bss_desc" to "failed to alloc beacon_ie" ?

Sincerely
Pierre Louis Aublin
