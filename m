Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0LOQzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:55:20 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:62765 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0LOQzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G4RIweb4tctTQKsfrisuR6M14K6TGqW4/Dl+xaIKo3UFRN3FC/TL1PjlXSzKJ7Ypwn
         InIdaGqExfxmYgrABmjzpa4Vcy1NQF5TAkuTPV6KDgO4Va4yl8t7dtQQmaCezZsVXAtt
         jCFz7RtM7ScBg4ROBSeA5ybMNfau+TEOXVTVY=
MIME-Version: 1.0
In-Reply-To: <4D08F21B.3000706@kernel.org>
References: <20101214174847.887713690@linux.com>
	<20101214174901.827380447@linux.com>
	<4D08F21B.3000706@kernel.org>
Date: Wed, 15 Dec 2010 18:55:17 +0200
X-Google-Sender-Auth: PiMF6azveT2lnH8y-nr1zngVTl8
Message-ID: <AANLkTik8Wnhvr+7h=rwpxmBHSnyvdT0uu77CMELTVUTd@mail.gmail.com>
Subject: Re: [cpuops cmpxchg double V1 4/4] Lockless (and preemptless)
 fastpaths for slub
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Dec 15, 2010 at 6:51 PM, Tejun Heo <tj@kernel.org> wrote:
> The first two look good to me but I frankly don't have much idea about
> the latter two.  Pekka, can you please ack those?  Alternatively, you
> can later pull the percpu tree in and apply the allocator bits in your
> tree, which I actually prefer.

I'd prefer to pull the first two from your tree and put the allocator
changes to slab.git.

                        Pekka
