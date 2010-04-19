Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0DSWLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab0DSWLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:11:05 -0400
Message-ID: <4BCCD4BD.3030303@redhat.com>
Date: Mon, 19 Apr 2010 15:10:05 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] fcntl.h: define AT_EACCESS
References: <1271387280-19565-1-git-send-email-max@stro.at> <20100419144729.2b8180e8.akpm@linux-foundation.org> <20100419215711.GR10984@baikonur.stro.at>
In-Reply-To: <20100419215711.GR10984@baikonur.stro.at>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/19/2010 02:57 PM, maximilian attems wrote:
> the dash code calling faccessat has the 4 params,
> klibc faccessat had only 3 args, guess nobody had used it before.

The function is implemented at userlevel.  The kernel code has the same
name but isn't a complete implementation.  There is no point in defining
the symbol in the kernel headers.

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkvM1L0ACgkQ2ijCOnn/RHS1zgCggyyqLkOWD7dyOeLOiC314niu
+MYAoKQVKnG3DSZii9lodwvIHkBIppEF
=y6bR
-----END PGP SIGNATURE-----
