Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2KMKsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:48:50 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:48755 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2KMKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:48:49 -0500
Date: Tue, 13 Nov 2012 11:48:39 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] net: xfrm: use __this_cpu_read per-cpu helper
Message-ID: <20121113104839.GJ22290@secunet.com>
References: <50A1A7C9.3060703@gmail.com>
 <20121113072101.GG22290@secunet.com>
 <50A213DF.1040103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A213DF.1040103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Nov 2012 10:48:39.0486 (UTC) FILETIME=[70C085E0:01CDC18C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 05:33:19PM +0800, Shan Wei wrote:
> Steffen Klassert said, at 2012/11/13 15:21:
> > 
> > This should just fetch the tfm pointer, so why exactly __this_cpu_read
> > is better than __this_cpu_ptr? Please keep in mind that performance is
> > not the most important thing here. It's much more important that it
> > works in any case.
>  
> [0/9] describes why we should submit this series patches.
> you are not included in original mail.
> 
> this_cpu_ptr relocates and address. this_cpu_read() relocates the address
> and performs the fetch. If you want to operate on rda(defined as per_cpu) 
> then you can only use this_cpu_ptr. this_cpu_read() saves you more instructions
> since it can do the relocation and the fetch in one instruction.
> 

Ok, so please add a commit message to describe your changes.

Thanks.
