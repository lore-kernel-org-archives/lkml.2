Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1GQVrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:47:49 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45524 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752576Ab1GQVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:47:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=n8SE5RsZJZGTpTcu1dFhQf25Wrg1eYQhs7EkMM7wpyojY1xgfxOn4NnV1O0pBSqOKoTYYfYLNeowr0bV6UdtCdFawQq8oJRbrV41QwngWyDBVAGWlqsUk2DBn5ZTcBaO;
Date: Sun, 17 Jul 2011 14:47:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
Message-Id: <20110717144746.78063c97.rdunlap@xenotime.net>
In-Reply-To: <20110707171627.4f15035e.akpm@linux-foundation.org>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 17:16:27 -0700 Andrew Morton wrote:

> It is just me, or is headers_check busted in current -linus?
> 
> z:/usr/src/25> make mrproper; make allmodconfig; make headers_check
> ...
> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

What does it take to reproduce this?
Does it fail on either type of X86 or is this from some other $ARCH?
I can't make it fail on X86 (3.0-rc7).

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
