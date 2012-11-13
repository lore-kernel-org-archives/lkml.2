Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2KMH1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:27:10 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:44241 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2KMH1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:27:09 -0500
Date: Tue, 13 Nov 2012 08:27:03 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Shan Wei <shanwei88@gmail.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org
Subject: Re: [PATCH v4 5/9] kernel: padata : use __this_cpu_read per-cpu
 helper
Message-ID: <20121113072703.GH22290@secunet.com>
References: <50A1A7E1.3030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A1A7E1.3030401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Nov 2012 07:27:03.0933 (UTC) FILETIME=[473D9AD0:01CDC170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:52:33AM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> For bottom halves off, __this_cpu_read is better.
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Herbert, are you going to take this one?

