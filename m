Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1HaEkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:40:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:52371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1HaEj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:39:58 -0400
Subject: Re: undefined reference to `sys_nfsservctl'
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <alpine.DEB.2.01.1108290809260.9183@trent.utfs.org>
Date: Tue, 30 Aug 2011 23:38:48 -0500
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        lkml list <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com,
        neilb@suse.de, bfields@redhat.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Message-Id: <6C86E8D5-E93C-4D37-8D86-03F88309CD44@kernel.crashing.org>
References: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org> <20110829161726.c980a80258fe714db49b425b@canb.auug.org.au> <alpine.DEB.2.01.1108290809260.9183@trent.utfs.org>
To: Christian Kujau <lists@nerdbynature.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 29, 2011, at 10:11 AM, Christian Kujau wrote:

> On Mon, 29 Aug 2011 at 16:17, Stephen Rothwell wrote:
>>>  MODPOST vmlinux.o
>>> WARNING: modpost: Found 1 section mismatch(es).
>>> To see full details build your kernel with:
>>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>>  GEN     .version
>>>  CHK     include/generated/compile.h
>>>  UPD     include/generated/compile.h
>>>  CC      init/version.o
>>>  LD      init/built-in.o
>>>  LD      .tmp_vmlinux1
>>> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
>>> (.text+0x5be0): undefined reference to `sys_nfsservctl'
>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>> make: *** [sub-make] Error 2
>> 
>> I posted a patch to Linus earlier today (subject of lkml message:
>> "linux-next: build failure in Linus' tree").
> 
> Ah, thanks. Will try. Meanwhile I've just reverted 
> f5b940997397229975ea073679b03967932a541b (All Arch: remove linkage for 
> sys_nfsservctl system call) and it compiled w/o errors too.
> 
> Christian.

Posted patch to fix this on PPC.  Hopefully BenH will notice ;)

- k
