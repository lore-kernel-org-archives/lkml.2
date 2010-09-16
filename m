Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IPQL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:11:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37072 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IPQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:11:55 -0400
Date: Thu, 16 Sep 2010 09:11:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 16 (do_mounts.c)
Message-Id: <20100916091125.f12cc17c.randy.dunlap@oracle.com>
In-Reply-To: <20100916152805.c9f31656.sfr@canb.auug.org.au>
References: <20100916152805.c9f31656.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 15:28:05 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100915:


When CONFIG_BLOCK is not enabled:

init/do_mounts.c:71: error: implicit declaration of function 'dev_to_part'
init/do_mounts.c:71: warning: initialization makes pointer from integer without a cast
init/do_mounts.c:73: error: dereferencing pointer to incomplete type
init/do_mounts.c:76: error: dereferencing pointer to incomplete type
init/do_mounts.c:76: error: dereferencing pointer to incomplete type
init/do_mounts.c:102: error: implicit declaration of function 'part_pack_uuid'
init/do_mounts.c:104: error: 'block_class' undeclared (first use in this function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
