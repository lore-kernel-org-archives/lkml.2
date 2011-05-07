Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1EGBfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:35:20 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54085 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752207Ab1EGBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:35:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Mt4/xneK1agmxdkdNTUUZ7YxtbZSBS4PdHfXl4I58OSZKrcplPJCXiWznLz9rjLy3dD/EVrxffVpGcy5LenqKf4n4ARynHzfM2UsiST4bVWdAGG4eEunkR96ZhZBmsNN;
Date: Fri, 6 May 2011 18:35:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org, Stephen Wilson <wilsons@start.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2011-05-06-16-39 uploaded (fs/proc/task_mmu)
Message-Id: <20110506183517.29369143.rdunlap@xenotime.net>
In-Reply-To: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
References: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 16:39:31 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-05-06-16-39 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.39-rc6:

from "mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch":

on i386 (X86_32):

fs/proc/task_mmu.c:981: error: implicit declaration of function 'mpol_to_str'

when CONFIG_SHMEM=n, CONFIG_TMPFS=n, and these NUMA config settings:

CONFIG_X86_NUMAQ=y
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_NUMA=y
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
CONFIG_AMD_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_USE_PERCPU_NUMA_NODE_ID=y


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
