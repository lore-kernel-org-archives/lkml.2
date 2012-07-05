Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2GEQKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:10:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55469 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2GEQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:10:00 -0400
Message-ID: <4FF5BC54.2060506@gmail.com>
Date: Thu, 05 Jul 2012 11:09:56 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usage-model.txt: fix typo machine_init->init_machine
References: <1340966686-26430-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1340966686-26430-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:44 AM, Richard Genoud wrote:
> machine_init was used intead of init_machine which clearly was not
> intended.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---

Applied for 3.6.

Rob


>  Documentation/devicetree/usage-model.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/usage-model.txt b/Documentation/devicetree/usage-model.txt
> index c5a8009..dca90fe 100644
> --- a/Documentation/devicetree/usage-model.txt
> +++ b/Documentation/devicetree/usage-model.txt
> @@ -312,7 +312,7 @@ device tree for the NVIDIA Tegra board.
>  	};
>  };
>  
> -At .machine_init() time, Tegra board support code will need to look at
> +At .init_machine() time, Tegra board support code will need to look at
>  this DT and decide which nodes to create platform_devices for.
>  However, looking at the tree, it is not immediately obvious what kind
>  of device each node represents, or even if a node represents a device
> 

