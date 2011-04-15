Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1DOQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:12:05 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37801 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751274Ab1DOQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:12:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lQt22O8VYwbAbgCZlxjkzwo6NhlbzCTvaQFD9YETsgPd9Avnj6s3fHqG8bpeBcbYBhxDyoToEG58Y2UhLrgMwYT2b2KzxVwhSUS+4t/O4YwtzORxpvT+rKG0lHgEQw6y;
Date: Fri, 15 Apr 2011 09:12:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org, Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-04-14-15-08 uploaded (staging/gma500)
Message-Id: <20110415091200.91cb2af8.rdunlap@xenotime.net>
In-Reply-To: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 15:08:47 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-04-14-15-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.39-rc3:


ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

on x86_64

in psb_intel_wait_for_vblank().

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
