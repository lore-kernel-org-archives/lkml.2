Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0HPHII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:08:08 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:35422 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab0HPHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:08:07 -0400
Date: Mon, 16 Aug 2010 09:13:09 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] padata: add missing __percpu markup in
 include/linux/padata.h
Message-ID: <20100816071309.GB2796@secunet.com>
References: <20100811182925.GB4097@secunet.com>
 <1281610467-9414-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281610467-9414-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Aug 2010 07:08:01.0756 (UTC) FILETIME=[C3B839C0:01CB3D11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:54:27PM +0900, Namhyung Kim wrote:
> parallel_data->queue is a percpu pointer but was missing __percpu markup.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks,

Steffen

