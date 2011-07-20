Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1GTQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:38:33 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35789 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751543Ab1GTQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:38:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Bn/zEl0Zk9dQRvLAuajX+xU/v4lQywoYBTFOLm8XDbRk4un1D6p7q+k4SaPuWkjGDgj3FNUWuDPly1dynKi/uyb04lx6jUKYCf7BsRq0AMcLoGmeKfbYN7zzOKYv3e5I;
Date: Wed, 20 Jul 2011 09:38:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-acpi@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 20 (acpi/apei/ghes)
Message-Id: <20110720093829.aae2ec63.rdunlap@xenotime.net>
In-Reply-To: <20110720093633.ca9cf794.rdunlap@xenotime.net>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
	<20110720093633.ca9cf794.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 09:36:33 -0700 Randy Dunlap wrote:

> On Wed, 20 Jul 2011 18:00:41 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> On i386 (X86_32):
> 
> drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
> drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression
> 
> ghes.c:(.text+0x46289): undefined reference to `__udivdi3'
>   in function ghes_estatus_cache_add().

That's on:
		period = duration / (count + 1);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
