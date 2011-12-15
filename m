Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1LODpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:45:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52784 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755889Ab1LODpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:45:54 -0500
Message-ID: <1323920752.29500.11.camel@joe2Laptop>
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool
 (net & drivers/net)
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Wed, 14 Dec 2011 19:45:52 -0800
In-Reply-To: <877h1ysenl.fsf@rustcorp.com.au>
References: <877h1ysenl.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 13:51 +1030, Rusty Russell wrote:
> module_param(bool) used to counter-intuitively take an int.  In
> fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> trick.
[]
> diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
[]
> @@ -38,15 +38,15 @@ MODULE_ALIAS_LDISC(N_CAIF);
[]
> -static int ser_use_stx = 1;
> +static bool ser_use_stx = 1;

Could you respin these please using bool foo = true/false instead?


