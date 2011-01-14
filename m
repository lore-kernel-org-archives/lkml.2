Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1ANSsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:48:20 -0500
Received: from waste.org ([173.11.57.241]:55253 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592Ab1ANSsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:48:19 -0500
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
From: Matt Mackall <mpm@selenic.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
References: <20110114181609.GN2822@pulham.picochip.com>
	 <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 12:48:15 -0600
Message-ID: <1295030895.30392.21.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 18:44 +0000, Jamie Iles wrote:
> This driver adds support for the True Random Number Generator in
> the Picochip PC3X3 and later devices.
> 
> v2: fix indentation and cleanup read function to remove single use
> variables and to take advantage of the rng buffer being aligned.
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.


