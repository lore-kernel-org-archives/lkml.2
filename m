Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0FLBdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:33:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45163 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0FLBdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:33:24 -0400
Date: Fri, 11 Jun 2010 18:31:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100611183152.7537b30b.randy.dunlap@oracle.com>
In-Reply-To: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C12E3DB.0175:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 16:40:13 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.35-rc2:

> mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
> mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch

latter patch file contains patches to mm/rmap.c.orig,
which patch FAILs to apply:

Applying patch mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
patching file mm/rmap.c
patching file mm/rmap.c.orig
Hunk #1 FAILED at 236.
Hunk #2 succeeded at 253 with fuzz 2 (offset -12 lines).
Hunk #3 succeeded at 1343 (offset -58 lines).
1 out of 3 hunks FAILED -- rejects in file mm/rmap.c.orig
Patch mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch does not apply (enforce with -f)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
