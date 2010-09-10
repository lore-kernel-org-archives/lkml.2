Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0IJJJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:09:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52617 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0IJJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UgiLaYkNBexCF8nrMG7hc3AAjflGJn/yJ2q+P4KVS3AHnE5qeL0itc2QZdHmTka8Ey
         YBg9pHyBumdkSHob+Ss4m93Dt9b6tHBK6mNN1XOo4NIe4aT+teVh03sj9jX9EMwSZ1Xd
         57DPrwyJYUPRQGPG35R5+1Zj4kRJaisOnis9E=
Subject: Re: [PATCH] percpu: update comments to reflect that percpu
 allocations are always zero-filled
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
In-Reply-To: <4C89F47D.20309@kernel.org>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	 <1284040322.2589.174.camel@edumazet-laptop>
	 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
	 <1284106566.402.26.camel@laptop>	<4C89EF37.5080803@kernel.org>
	 <AANLkTi=7PJPCwrnK+4ejX7RHC-sautVgK-_+kpoT27k5@mail.gmail.com>
	 <4C89F47D.20309@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 11:09:14 +0200
Message-ID: <1284109754.24675.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 septembre 2010 à 11:03 +0200, Tejun Heo a écrit :
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephane Eranian <eranian@google.com>
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


