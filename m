Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1K0SVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:21:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54795 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1K0SVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:21:33 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1322313066.6001.3.camel@phoenix>
References: <1322313066.6001.3.camel@phoenix>
Date: Sun, 27 Nov 2011 10:21:32 -0800
Message-ID: <CAOesGMiJkkNqbG6QGOZqABSaJ1nRccA5pzxbUSA+vwaASkKkDg@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: convert drivers/char/hw_random/* to use module_platform_driver()
From: Olof Johansson <olof@lixom.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Clouter <alex@digriz.org.uk>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 5:11 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/char/hw_random/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Alexander Clouter <alex@digriz.org.uk>
> Cc: David Daney <ddaney@caviumnetworks.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Olof Johansson <olof@lixom.net>
