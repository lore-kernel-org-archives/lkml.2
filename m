Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0HBPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:13:58 -0400
Received: from stinky.trash.net ([213.144.137.162]:61754 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0HBPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:13:56 -0400
Message-ID: <4C56E0B4.40800@trash.net>
Date: Mon, 02 Aug 2010 17:13:56 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Meik Piepmeyer <meik.piepmeyer.lists@online.de>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] netfilter : fix typo in Kconfig
References: <4C50269B.2010908@online.de>
In-Reply-To: <4C50269B.2010908@online.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2010 14:46, Meik Piepmeyer wrote:
> From: Meik Piepmeyer <meik.piepmeyer.lists@online.de>
> 
> Fixes a typo of the description of the new netfilter config switch
> "NETFILTER_XT_TARGET_RATEEST" introduced in 2.6.35.
> 
>  config NETFILTER_XT_TARGET_TEE
> -	tristate '"TEE" - packet cloning to alternate destiantion'
> +	tristate '"TEE" - packet cloning to alternate destination'
>  	depends on NETFILTER_ADVANCED
>  	depends on (IPV6 || IPV6=n)
>  	depends on !NF_CONNTRACK || NF_CONNTRACK
> 

This has already been fixed a few weeks ago.
