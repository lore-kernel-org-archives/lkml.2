Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1DOQZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:25:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21165 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1DOQZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:25:29 -0400
Date: Fri, 15 Apr 2011 09:24:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
Message-Id: <20110415092418.b18fd6fe.randy.dunlap@oracle.com>
In-Reply-To: <4D9C2FF6.7090607@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	<1301665762.2160.22.camel@gandalf.stny.rr.com>
	<4D9C2FF6.7090607@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4DA87171.0080:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Apr 2011 17:18:46 +0800 liubo wrote:

> 
> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
> on 32bit box.

Hi,

Can this also be used to stop this warning that has been around
like forever (on i386)?

linux-next-20110415/fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
