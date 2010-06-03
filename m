Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0FCTxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:53:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52668 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0FCTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q2BQVOoJucmDKgsgYKGrsjujby3uUjlpVYbeA5gtna33FgwM9uf4YVLGZEUzXU5pYj
         y9G1MIjpwW2tNJaf+xvvcAy23Wnf/JCd5hK0NwARDCqstKyOyPgffVA6986TvDfNvM4L
         c+qZ70CUgoO6vIlr1OtOHHqBPthjaP4XaAOq0=
Date: Thu, 3 Jun 2010 21:53:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: unify save_stack_address() and
	save_stack_address_nosched()
Message-ID: <20100603195328.GD5234@nowhere>
References: <20100603193243.GA31534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603193243.GA31534@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:32:43PM +0200, Oleg Nesterov wrote:
> Cleanup. Factor the common code in save_stack_address() and
> save_stack_address_nosched().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

