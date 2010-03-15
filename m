Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab0COQBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965216Ab0COQBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:01:22 -0400
Message-ID: <4B9E59B7.6060405@redhat.com>
Date: Mon, 15 Mar 2010 09:00:55 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <1268628493.2355.2.camel@pasglop> <20100314.220646.190065794.davem@davemloft.net> <1268630313.2335.2.camel@pasglop> <20100315134449.GB1653@linux-mips.org> <4B9E4EB1.9010800@zytor.com>
In-Reply-To: <4B9E4EB1.9010800@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/15/2010 08:13 AM, H. Peter Anvin wrote:
> One option would be to do a libkernel.so,

No need.  Put it in the vdso.  And name it something other than syscall.
 The syscall() API is fixed, you cannot change it.

All this only if it makes sense for ALL archs.  If it cannot work for
just one arch then it's not worth it at all.

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkueWbcACgkQ2ijCOnn/RHRtBQCeP88S/0xei7CAt65AGboqsrC8
N7wAoK7Qbi+OZuQrgHTCgTA27TgY+gQU
=4tJ6
-----END PGP SIGNATURE-----
