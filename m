Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0EFEoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 00:44:19 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37639 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0EFEoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 00:44:18 -0400
Date: Thu, 6 May 2010 13:42:48 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: mmotm-2010-0428: swapper_space error
Message-Id: <20100506134248.aaba5d0f.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100501084927.2f6c88f6.rdunlap@xenotime.net>
References: <20100501084927.2f6c88f6.rdunlap@xenotime.net>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry...

I'll re-check my build test script and prepare a patch as soon as possible.

On Sat, 1 May 2010 08:49:27 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> mm/built-in.o: In function `mem_cgroup_get_shmem_target':
> (.text+0x1f681): undefined reference to `swapper_space'
> 
> .config attached.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
