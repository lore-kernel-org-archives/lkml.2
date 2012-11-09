Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2KINzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:55:12 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49299 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KINzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:55:09 -0500
Message-ID: <509D0B39.1000203@gmail.com>
Date: Fri, 09 Nov 2012 07:55:05 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Add vendor prefix for ON Semiconductor Corp.
References: <1352466421-27480-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352466421-27480-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 07:07 AM, Thierry Reding wrote:
> The used vendor prefix corresponds to the stock symbol (ONNN) for ON
> Semiconductor Corp.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Applied. Thanks.

Rob

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index ac2c2c4..deba8d0 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -34,6 +34,7 @@ national	National Semiconductor
>  nintendo	Nintendo
>  nvidia	NVIDIA
>  nxp	NXP Semiconductors
> +onnn	ON Semiconductor Corp.
>  picochip	Picochip Ltd
>  powervr	Imagination Technologies
>  qcom	Qualcomm, Inc.
> 

