Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab2EIOGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:06:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2EIOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:06:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] bitops: add _local bitops
Date: Wed, 9 May 2012 14:06:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
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
References: <20120509134528.GA18044@redhat.com>
In-Reply-To: <20120509134528.GA18044@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091406.15627.arnd@arndb.de>
X-Provags-ID: V02:K0:CXxHochwWzmZEHrkz670Ij7oAxZPqfUuEyMpKN7OIAY
 G2tySxjTcAT+SHuT2TxvRD0BKonSwXqzbkQs7MI9nRueTIeoQB
 Epxn3iGsn9LCeGeEfLZ+zo60k2zc8GZh/vNUusZmCO5zYPTFwe
 3LqGLpakhPq7OvUDTkwXdCjj+c5g4X2xK/Ubi9P1w5baxJ1rD0
 7XwvDSEjKG8lZt943bpC+vI5ZIhKPlAIdoCEfw7UrjiP1VwxS4
 D5U0/KyTQ3r3YRfIGy/1T0gXLPJy54upsmGTUR9dL8yGvrB9sW
 9ajLMysPtaRu0mQlJInkgBX/ksdCmgwFyIA2BQxC2PlaCT5tHi
 SWdfNYqs24yvBDV04RP0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Michael S. Tsirkin wrote:
>  Documentation/atomic_ops.txt              |   19 ++++++
>  arch/x86/include/asm/bitops.h             |    1 +
>  include/asm-generic/bitops.h              |    1 +
>  include/asm-generic/bitops/local-atomic.h |   92 +++++++++++++++++++++++++++++
>  include/asm-generic/bitops/local.h        |   85 ++++++++++++++++++++++++++
>  include/linux/bitops.h                    |    8 +++
>  6 files changed, 206 insertions(+), 0 deletions(-)

Unless I'm misreading the patch, you have two versions of the same file here,
where one version should be enough.

Both versions look fine to me though, so if you remove one of them:

Acked-by: Arnd Bergmann <arnd@arndb.de>
