Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2KMFNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:13:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48955 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2KMFNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:13:17 -0500
Message-ID: <50A1D6ED.50001@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:13:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] MIPS: BCM63XX: enable serial through Device Tree
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-16-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-16-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Enable serial through Device Tree board files instead of legacy
> board files.

> diff --git a/arch/mips/bcm63xx/dts/96328avng.dts b/arch/mips/bcm63xx/dts/96328avng.dts

>  	ubus@10000000 {
>  
> +		serial@100 {

Very minor nit: Why the blank line there?

> +			status = "ok";
> +		};
>  	};
>  };

