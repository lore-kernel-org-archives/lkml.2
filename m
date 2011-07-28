Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1G1WXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:23:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33082 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1G1WXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:23:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jmMpyvSu+v7iVDyQyzmc98dS6FVzKEPTaDrm5ZarTUo/HLuPQjifQHj2SvDqwAvVb
	tWwNkP3FlDSWzO69SDo/g==
Date: Thu, 28 Jul 2011 15:22:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
In-Reply-To: <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1107281514080.29344@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107221108190.2996@tiger> <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Pekka Enberg wrote:

> Christoph, your debugging fix has been in linux-next for few days now
> and no problem have been reported. I'm considering sending the series
> to Linus. What do you think?
> 

I ran slub/lockless through some stress testing and it seems to be quite 
stable on my testing cluster.  There is about a 2.3% performance 
improvement with the lockless slowpath on the netperf benchmark with 
various thread counts on my 16-core 64GB Opterons, so I'd recommend it to 
be merged into 3.1.
