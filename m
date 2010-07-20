Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab0GTESh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:18:37 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:45419 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0GTESf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:18:35 -0400
Message-ID: <4C452399.3050708@tilera.com>
Date: Tue, 20 Jul 2010 00:18:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jiri Slaby <jirislaby@gmail.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the limits tree with the tile tree
References: <20100720134833.4082eed4.sfr@canb.auug.org.au>
In-Reply-To: <20100720134833.4082eed4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/2010 11:48 PM, Stephen Rothwell wrote:
> Hi Jiri,
>
> Today's linux-next merge of the limits tree got a conflict in
> include/asm-generic/unistd.h between commits
> 5360bd776f73d0a7da571d72a09a03f237e99900 ("Fix up the "generic" unistd.h
> ABI to be more useful") and b51cae21ee66f77a368428e6bdf75a0c012c9fd7
> ("Add wait4() back to the set of <asm-generic/unistd.h> syscalls") from
> the tile tree and commit f33ebbe9da2c3c24664a0ad4f8fd83f293547e63
> ("unistd: add __NR_prlimit64 syscall numbers") from the limits tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
>   

Jiri, would it be possible to put __NR_prlimit64 as number 261 in
<asm-generic/syscall.h>?  This would avoid the requirement for Tilera
users to have a "flag day" to renumber some of our syscalls.  I assume
there are no users at all of this flavor of the __NR_prlimit64 syscall
number yet otherwise, except the "score" architecture folks who
presumably wouldn't have started trying to use the syscall yet.

Thanks, and Stephen, thanks for the fixup.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

