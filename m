Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2I1GHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:07:21 -0400
Received: from ozlabs.org ([203.10.76.45]:44517 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2I1GHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:07:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 28 Sep 2012 15:25:17 +0930
Message-ID: <87r4pm3d4q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Hi Rusty,
>
> Could you pull my tree?
>
> David
> ---
>
> The following changes since commit eeea3ac912207dcf759b95b2b4c36f96bce583bf:
>
>   Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-09-06 10:23:58 -0700)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git modsign-post-KS
>
> for you to fetch changes up to 15765081423824e1ccc329264ae13f5ea87f3a85:
>
>   MODSIGN: Sign modules during the build process (2012-09-26 10:11:06 +0100)

warning: (MODULE_SIG) selects ASYMMETRIC_KEY_TYPE which has unmet direct dependencies (CRYPTO && KEYS)

Ah, I see:

+	select CONFIG_KEYS
+	select CONFIG_CRYPTO

I fixed this commit, rather than go around again.

Thanks,
Rusty.
