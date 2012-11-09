Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2KIR0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:26:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54166 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2KIR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:26:42 -0500
Message-ID: <509D3CD0.4070006@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:26:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: tamonten: Add temperature sensor support
References: <1352466474-27581-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352466474-27581-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:07 AM, Thierry Reding wrote:
> The Tamonten SOM has an ON Semiconductor NCT1008 connected to the DVC
> bus which is used to measure the ambient (local) temperature as well as
> the on-die (remote) temperature.

> diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi

> +		nct1008@4c {

Given nodes are typically named after object type, should that be:

		temperature-sensor@4c {

as it is on Seaboard?

> +			compatible = "onnn,nct1008";
> +			reg = <0x4c>;
> +		};
>  	};
>  
>  	pmc {
> 

