Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0EZGds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:33:48 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42872 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0EZGdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:33:46 -0400
Date: Wed, 26 May 2010 08:32:27 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Carpenter <error27@gmail.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Henrik Kretzschmar <henne@nachtwindheim.de>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] padata: add parenthesis in MAX_SEQ_NR macro
Message-ID: <20100526063227.GP2184@secunet.com>
References: <20100525212913.GK22515@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525212913.GK22515@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 May 2010 06:33:43.0375 (UTC) FILETIME=[62F4B5F0:01CAFC9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:29:13PM +0200, Dan Carpenter wrote:
> MAX_SEQ_NR is used in padata_alloc_pd() like this:
> 
>         pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
> 
> It needs parenthesis or the divide by num_cpus takes precedence over the
> subtraction.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks,

Steffen
