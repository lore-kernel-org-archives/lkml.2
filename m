Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1FPBaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 21:30:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab1FPBaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 21:30:18 -0400
Date: Wed, 15 Jun 2011 18:29:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-15-16-56 uploaded (UML build error)
Message-Id: <20110615182958.d5aad636.randy.dunlap@oracle.com>
In-Reply-To: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DF95CA1.0104:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 16:56:49 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-06-15-16-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
>    git://zen-kernel.org/kernel/mmotm.git
> or
>    git://git.cmpxchg.org/linux-mmotm.git
> 
> It contains the following patches against 3.0-rc3:


When building UML for x86_64 (defconfig), I get:

fs/built-in.o: In function `__bprm_mm_init':
mmotm-2011-0615-1656/fs/exec.c:280: undefined reference to `__build_bug_on_failed'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
