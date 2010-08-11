Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0HKSYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:24:42 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:57918 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0HKSYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:24:41 -0400
Date: Wed, 11 Aug 2010 20:29:25 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: add missing __percpu markup in
 include/linux/padata.h
Message-ID: <20100811182925.GB4097@secunet.com>
References: <1281199645-26274-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281199645-26274-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2010 18:24:37.0954 (UTC) FILETIME=[74DFB220:01CB3982]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 01:47:25AM +0900, Namhyung Kim wrote:
> parallel_data->queue is a percpu pointer but was missing __percpu markup.
> Add it.
> 

The patch does not apply,  please respin against linux-2.6 git current.

Thanks,

Steffen
