Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab0C0E3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 00:29:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:39662 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0C0E3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:29:40 -0400
Date: Fri, 26 Mar 2010 21:27:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, eduard.munteanu@linux360.ro,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kmemtrace.txt question: kernel parameter(s)?
Message-Id: <20100326212726.cea150c3.randy.dunlap@oracle.com>
In-Reply-To: <4B2AD38D.3070605@cn.fujitsu.com>
References: <20091217141342.9ae2072b.randy.dunlap@oracle.com>
	<4B2AD38D.3070605@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BAD8997.006E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 08:57:49 +0800 Li Zefan wrote:

> Randy Dunlap wrote:
> > Hi,
> > 
> > Documentation/trace/kmemtrace.txt says:
> > 
> > Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
> > this? Should I worry?
> > A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
> > large the number is. You can fix it by supplying a higher
> > 'kmemtrace.subbufs=N' kernel parameter.
> > 
> > 
> > Where is this kernel parameter implemented and where is it documented?
> > or should this Answer just be fixed?
> > 
> 
> The whole documentation is out-dated. The original kmemtrace was based on
> relay, and then it moved to ftrace, without updating the documentation.

Sorry for the delay.

Shouldn't Documentation/trace/kmemtrace.txt just be completely deleted?

It's confusing and all relevant kmemtrace documentation is elsewhere.

---
~Randy
