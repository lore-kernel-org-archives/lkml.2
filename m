Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2F1FUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:20:43 -0400
Received: from nbd.name ([46.4.11.11]:54982 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2F1FUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:20:42 -0400
Message-ID: <4FEBE95B.8060501@openwrt.org>
Date: Thu, 28 Jun 2012 07:19:23 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: Roland Stigge <stigge@antcom.de>, jkosina@suse.cz, standby24x7@gmail.com,
        bhelgaas@google.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH RESEND] mips: pci-lantiq: Fix check for valid gpio
References: <1340836617-21666-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1340836617-21666-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/12 00:36, Roland Stigge wrote:
> This patch fixes two checks for valid gpio number, formerly (wrongly)
> considering zero as invalid, now using gpio_is_valid().
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: John Crispin <blogic@openwrt.org>



Hi Ralf,

can you take this via your tree ?

Thanks,
John




