Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2JJKCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:02:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab2JJKCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:02:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
References: <874nmd4d2o.fsf@rustcorp.com.au> <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk> <23688.1349186865@warthog.procyon.org.uk> <87ehlf2l9w.fsf@rustcorp.com.au> <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 10 Oct 2012 20:07:11 +1030
Message-ID: <87ipai7jnc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> writes:
> http://git.kernel.org/?p=linux/kernel/git/rusty/linux.git;a=commit;h=a15e196c5543d1d2d7f0cd70e62351aeb1f8b871
>
> It breaks bisect..
>
>   CC      kernel/module_signing.o
> kernel/module_signing.c: In function ‘mod_verify_sig’:
> kernel/module_signing.c:21:10: error: ‘ENOKEY’ undeclared (first use
> in this function)
> kernel/module_signing.c:21:10: note: each undeclared identifier is
> reported only once for each function it appears in
> kernel/module_signing.c:22:1: warning: control reaches end of non-void
> function [-Wreturn-type]
> make[1]: *** [kernel/module_signing.o] Error 1
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....

Ah, my mistake; missing #include.  I've fixed this which unfortunately
meant a rebase.

Thanks,
Rusty.
