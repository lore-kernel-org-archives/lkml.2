Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2KDPvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:51:15 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32954 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2KDPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:51:10 -0500
Date: Sun, 4 Nov 2012 15:51:05 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
Message-ID: <20121104155105.GA29336@page>
References: <1352043385.11324.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352043385.11324.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, Nov 04, 2012 at 11:36:25PM +0800, Axel Lin wrote:
> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Good spot!  Thanks for fixing.

Acked-by: Jamie Iles <jamie@jamieiles.com>

Jamie
