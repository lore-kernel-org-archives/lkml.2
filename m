Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0GSGiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:38:00 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45313 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0GSGh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:37:56 -0400
Date: Mon, 19 Jul 2010 08:40:50 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] padata: cpumasks
Message-ID: <20100719064050.GA11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719060426.GA19696@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Jul 2010 06:37:53.0507 (UTC) FILETIME=[EA5A5330:01CB270C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:04:26PM +0800, Herbert Xu wrote:
> 
> All applied.  Thanks!

Hm, I was just about to write some comments on these patches,
they still have some issues. For example, handling empty cpumasks
is broken again (NULL pointer dereference in padata_replace).
The cpu_index is zero for all cpus now, so can we leak objects
on cpu hotplug etc. Also I'm not that happy with some of the
API changes. I'll try to fix this up with some patches.

Steffen
