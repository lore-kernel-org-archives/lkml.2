Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab2EIQq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:46:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42329 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760314Ab2EIQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:46:22 -0400
Message-ID: <4FAA9F45.1080608@zytor.com>
Date: Wed, 09 May 2012 09:45:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
References: <20120509134528.GA18044@redhat.com> <4FAA7939.6040706@zytor.com> <20120509154734.GB20867@redhat.com> <4FAA9A49.8080900@zytor.com> <20120509163641.GA21344@redhat.com>
In-Reply-To: <20120509163641.GA21344@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 09:36 AM, Michael S. Tsirkin wrote:
> 
> Well it talks about a memory barrier, not an
> optimization barrier.
> 

Same thing.

> If compiler reorders code, changes will appear in
> the wrong order on the current processor,
> not just on other processors, no?

Yes.

For your _local I would just copy the atomic bitops but remote the locks
in most cases.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

