Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab2EIOR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab2EIORy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:17:54 -0400
Message-ID: <4FAA7C71.3040501@redhat.com>
Date: Wed, 09 May 2012 17:17:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
References: <20120509134528.GA18044@redhat.com>
In-Reply-To: <20120509134528.GA18044@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 04:45 PM, Michael S. Tsirkin wrote:
>  
> +Local versions of the bitmask operations are also provided.  They are used in
> +contexts where the operations need to be performed atomically with respect to
> +the local CPU, but no other CPU accesses the bitmask.  This assumption makes it
> +possible to avoid the need for SMP protection and use less expensive atomic
> +operations in the implementation.
> +They have names similar to the above bitmask operation interfaces,
> +except that _local is sufficed to the interface name.

suffixed (better: appended)

-- 
error compiling committee.c: too many arguments to function

