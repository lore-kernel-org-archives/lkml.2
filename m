Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab1LNXbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:31:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LNXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:31:17 -0500
Message-ID: <4EE931C0.30402@gmail.com>
Date: Wed, 14 Dec 2011 17:31:12 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] OF/device-tree: Add some entries to vendor-prefixes.txt
References: <1323905179-28355-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1323905179-28355-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 05:26 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> We are currently using 'cavium', 'cortina' and 'st', add them to the
> list of known prefixes.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Applied.

Rob

> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index afb9bff..6708797 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -8,7 +8,9 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
>  apm	Applied Micro Circuits Corporation (APM)
>  arm	ARM Ltd.
>  atmel	Atmel Corporation
> +cavium	Cavium, Inc.
>  chrp	Common Hardware Reference Platform
> +cortina	Cortina Systems, Inc.
>  dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
>  denx	Denx Software Engineering
>  epson	Seiko Epson Corp.
> @@ -36,6 +38,7 @@ schindler	Schindler
>  sil	Silicon Image
>  simtek
>  sirf	SiRF Technology, Inc.
> +st	STMicroelectronics
>  stericsson	ST-Ericsson
>  ti	Texas Instruments
>  wlf	Wolfson Microelectronics

