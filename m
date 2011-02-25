Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1BYSw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:52:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37299 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab1BYSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:52:57 -0500
Date: Fri, 25 Feb 2011 10:52:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 25 (mm/slub.c)
Message-Id: <20110225105205.5a1309bb.randy.dunlap@oracle.com>
In-Reply-To: <20110225175924.a95d616d.sfr@canb.auug.org.au>
References: <20110225175924.a95d616d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4D67FA7C.0175:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 17:59:24 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110224:


when CONFIG_SLUB_DEBUG is not enabled:

mm/slub.c:2728: error: implicit declaration of function 'slab_ksize'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
