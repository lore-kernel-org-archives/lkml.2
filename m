Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2JZD14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:27:56 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61566 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2JZD1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:27:55 -0400
Message-ID: <508A0337.2000608@gmail.com>
Date: Thu, 25 Oct 2012 22:27:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: l2cc: doc: fix device tree example typo
References: <20121024005306.GA32126@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024005306.GA32126@beefymiracle.amer.corp.natinst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 07:53 PM, Josh Cartwright wrote:
> The list of attributes above details the use of the 'filter-ranges'
> property, but the example improperly used 'filter-latency'.  Make these
> consistent by fixing up the example.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>

Applied for 3.8 (unless I get more to send for 3.7).

Rob

> ---
>  Documentation/devicetree/bindings/arm/l2cc.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> index 7ca5216..7c3ee3a 100644
> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> @@ -37,7 +37,7 @@ L2: cache-controller {
>          reg = <0xfff12000 0x1000>;
>          arm,data-latency = <1 1 1>;
>          arm,tag-latency = <2 2 2>;
> -        arm,filter-latency = <0x80000000 0x8000000>;
> +        arm,filter-ranges = <0x80000000 0x8000000>;
>          cache-unified;
>          cache-level = <2>;
>  	interrupts = <45>;
> 
