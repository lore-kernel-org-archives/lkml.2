Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1FFUsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:48:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20614 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1FFUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:48:03 -0400
Date: Mon, 6 Jun 2011 13:47:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [Oops]RFC:include/trace/events/btrfs.h
Message-Id: <20110606134719.b24ecc07.randy.dunlap@oracle.com>
In-Reply-To: <20110605034111.GA7215@gmail.com>
References: <20110605034111.GA7215@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DED3CE1.00FF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011 11:41:14 +0800 Harry Wei wrote:

> From: Harry Wei <harryxiyou@gmail.com>
> 
> When i compile 2.6.39.1, it shows something wrong
> like below. When i open the file include/trace/events/btrfs.h
> i don't know how to fix these oops. They just give the entry
> of the function. So i can't get the exact line of the warnings.
> Can anyone give me some suggestions?

Yeah, those line numbers (below) don't help very much.

There is a patch pending to fix these warnings.  It's from
liubo <liubo2009@cn.fujitsu.com>, posted on 2011-APR-19,
subject: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings on 32bit machine


> Thanks in advance.
> Harry Wei
> 
> In file included from include/trace/ftrace.h:283,
>                     from include/trace/define_trace.h:96,
> 		                     from include/trace/events/btrfs.h:667,
> 				                      from fs/btrfs/super.c:56:
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_transaction_commit���:
> include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__inode���:
> include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
>    include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_get_extent���:
>    include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>   include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
>   include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__ordered_extent���:
>   include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
>   include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
>   include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__writepage���:
>  include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
> nclude/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_writepage_end_io_hook���:
> clude/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_sync_file���:
> nclude/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
> nclude/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_delayed_tree_ref���:
> nclude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
> nclude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
> clude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
>  include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_delayed_data_ref���:
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__chunk���:
> include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_cow_block���:
> include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__reserved_extent���:
> include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
