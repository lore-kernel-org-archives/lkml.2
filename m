Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0C2IQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:16:04 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:35288 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750761Ab0C2IQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:16:01 -0400
Date: Mon, 29 Mar 2010 16:15:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: steffen.klassert@secunet.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100329081550.GA22334@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 07:53:46AM +0100, Henrik Kretzschmar wrote:
> This patch removes the __cupinit from padata_cpu_callback(),
> which is refered by the exportet function padata_alloc().
> 
> This could lead to problems if CONFIG_HOTPLUG_CPU is disabled,
> which should happen very often.
> 
> WARNING: kernel/built-in.o(.text+0x7ffcb): Section mismatch in reference from the function padata_alloc() to the function .cpuinit.text:padata_cpu_callback()
> The function padata_alloc() references
> the function __cpuinit padata_cpu_callback().
> This is often because padata_alloc lacks a __cpuinit
> annotation or the annotation of padata_cpu_callback is wrong.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
