Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0C2IFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:05:52 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:41538 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab0C2IFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:05:51 -0400
X-Greylist: delayed 1539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2010 04:05:51 EDT
Date: Mon, 29 Mar 2010 09:42:42 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100329074242.GA23247@secunet.com>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Mar 2010 07:40:07.0039 (UTC) FILETIME=[0D7218F0:01CACF13]
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

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks,

Steffen
