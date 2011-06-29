Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1F2VJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:09:57 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47266 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757863Ab1F2VJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:09:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YYf7sl5Sc6Spqk6EDigbdW+TYSLB3yCBPhGCdu/7xT5RiTARtRmv+BNQr2yZid5Nq1OPFARY384ljt2bYbMxp4ILT+d4XONWGWw/ufgW40o1RZ30eam2MtPFn/m9DGu8;
Date: Wed, 29 Jun 2011 14:06:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Message-Id: <20110629140630.5aefdda8.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:

> *** WARNINGS ***
> 
> 358 regressions:

>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 210
>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 8 has type 'ssize_t':  => 222

>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 146
>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 146

>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 708
>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 690


Can someone explain these warnings, please?  (signed size_t vs. ssize_t)

Is gcc confused?
Looks like a compiler issue to me.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
