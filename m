Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1F0P2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:28:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46918 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1F0P2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:28:11 -0400
Date: Mon, 27 Jun 2011 08:27:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for June 27 (uml)
Message-Id: <20110627082733.75e58ae4.randy.dunlap@oracle.com>
In-Reply-To: <20110627161656.688820b9.sfr@canb.auug.org.au>
References: <20110627161656.688820b9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E08A176.015D:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 16:16:56 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110624:


uml defconfig builds on x86 (32-bit and 64-bit) fail with:

fs/hostfs/hostfs_kern.c:756: error: 'mask' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
