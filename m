Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2GZPTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:19:45 -0400
Received: from oproxy10-pub.bluehost.com ([67.222.39.61]:48989 "HELO
	oproxy10-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752546Ab2GZPTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:19:42 -0400
Message-ID: <50115FCF.4060708@xenotime.net>
Date: Thu, 26 Jul 2012 08:18:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
References: <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au>
In-Reply-To: <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 10:04 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Please do not add anything to linux-next included branches/series that is
> destined for v3.7 until after v3.6-rc1 is released.
> 
> Reminder: do not rebase your branches before asking Linus to pull them ...
> 
> Changes since 20120725:
> 



uml on x86_64 (defconfig) build fails with:

  CC      arch/x86/um/../kernel/module.o
arch/x86/um/../kernel/module.c:96:5: error: redefinition of 'apply_relocate_add'
include/linux/moduleloader.h:64:19: note: previous definition of 'apply_relocate_add' was here
make[2]: *** [arch/x86/um/../kernel/module.o] Error 1



-- 
~Randy
