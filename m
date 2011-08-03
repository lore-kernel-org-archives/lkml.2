Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1HCRkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:40:39 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43904 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753169Ab1HCRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:40:33 -0400
Date: Wed, 3 Aug 2011 10:40:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 3 (efivars/pstore)
Message-Id: <20110803104030.3c6443ab.rdunlap@xenotime.net>
In-Reply-To: <20110803151651.687fc6f377e255eccf58301b@canb.auug.org.au>
References: <20110803151651.687fc6f377e255eccf58301b@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011 15:16:51 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Just in case anyone needs reminding:  Please do not add anything destined
> for v3.2 into linux-next included trees until after v3.1-rc1.


What is this warning about?  I don't see the problem.

The warning only happens on i386 AFAIK.  Must be some typedef glitch?

drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
