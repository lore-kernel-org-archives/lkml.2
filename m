Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2KGTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:25:58 -0500
Received: from nbd.name ([46.4.11.11]:56005 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2KGTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:25:57 -0500
Message-ID: <509AB581.2070908@openwrt.org>
Date: Wed, 07 Nov 2012 20:24:49 +0100
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Axel Lin <axel.lin@ingics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: lantiq: Remove ltq_pmx_disable() function
References: <1352303879.7614.2.camel@phoenix>
In-Reply-To: <1352303879.7614.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/12 16:57, Axel Lin wrote:
> Current code adds empty ltq_pmx_disable() because pinmux_check_ops() requires
> this callback to be defined.
>
> This is not required since commit 02b50ce4cb1
> "pinctrl: make pinmux disable function optional".
>
> Thus remove ltq_pmx_disable() function.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
>

for both of these feel free to add ...

Acked-by: John Crispin <blogic@openwrt.org>

Thanks,
     John
