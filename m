Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0ESRsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:48:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39760 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0ESRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:48:31 -0400
Date: Wed, 19 May 2010 10:48:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jens.axboe@oracle.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 19 (mm/page-writeback)
Message-Id: <20100519104800.5a43346f.randy.dunlap@oracle.com>
In-Reply-To: <20100519163554.80c7fcd3.sfr@canb.auug.org.au>
References: <20100519163554.80c7fcd3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BF4246A.016A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 16:35:54 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> We are in the merge window again.  I remind you all not to add stuff for
> 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> 
> Changes since 20100518:


When CONFIG_BLOCK is not enabled:

mm/page-writeback.c: In function 'laptop_mode_timer_fn':
mm/page-writeback.c:708: error: dereferencing pointer to incomplete type
mm/page-writeback.c:709: error: dereferencing pointer to incomplete type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
