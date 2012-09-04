Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2IDREF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:04:05 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:52918 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932450Ab2IDRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:04:03 -0400
Message-ID: <5046346F.802@xenotime.net>
Date: Tue, 04 Sep 2012 10:03:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for Sept 4 (uml + execve)
References: <20120904171330.f6b0a922a754ba0f3acc123b@canb.auug.org.au>
In-Reply-To: <20120904171330.f6b0a922a754ba0f3acc123b@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 12:13 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120824:
>


UML on x86_64 (defconfig):

fs/built-in.o: In function `kernel_execve':
fs/exec.c:2342: multiple definition of `kernel_execve'
arch/um/kernel/built-in.o:arch/um/kernel/syscall.c:57: first defined here
fs/built-in.o: In function `sys_execve':
fs/exec.c:2327: multiple definition of `sys_execve'
arch/um/kernel/built-in.o:arch/um/kernel/exec.c:77: first defined here


-- 

~Randy
