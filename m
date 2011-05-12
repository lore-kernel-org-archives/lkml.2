Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1ELBHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:07:16 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:54815 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750815Ab1ELBHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:07:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bqKv0Pv3DgGsvMysbhSkWPDzdt5N23tf0Wz6ZGzQpAg1HTLBqp9CwlbERlr9LtwJqGbDPXDZeZnIhBGsaU6VDi3it8o65DoUirlmgEhRJNNQP1G7mdDUC0FYiGmRSnXv;
Date: Wed, 11 May 2011 18:07:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
Message-Id: <20110511180711.6be689bd.rdunlap@xenotime.net>
In-Reply-To: <1305161873.15167.78.camel@deneb.localdomain>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	<20110511143442.7c163a74.rdunlap@xenotime.net>
	<1305161873.15167.78.camel@deneb.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 20:57:53 -0400 Mark Salter wrote:

> On Wed, 2011-05-11 at 14:34 -0700, Randy Dunlap wrote:
> > Please run the patches thru checkpatch.pl.  You don't have to fix
> > everything that it whines about, just use good judgment.
> 
> Thanks Randy.
> 
> Was there anything particular that jumped out at you. I did run
> checkpatch and there were 7 seven errors but none seemed fixable to
> me (unless there really is a way to get rid of kernel_thread). The
> warnings were almost all about exceeded 80 char line width. I have
> been working on those for a while and there's a lot less than there
> used to be! :-)

There was one in drivers/platform/c6x/ where a driver included asm/timer.h
instead of linux/timer.h (IIRC - I don't have the patch handy ATM to run it
again).  checkpatch said to use linux/ instead of asm/.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
