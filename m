Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab1EXVjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933493Ab1EXVjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (suspend tree related)
Date: Tue, 24 May 2011 23:40:20 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110524134216.1033c885.sfr@canb.auug.org.au>
In-Reply-To: <20110524134216.1033c885.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105242340.21104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 24, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> kernel/swsusp.c:13:25: error: asm/suspend.h: No such file or directory
> kernel/power/hibernate.c:28:25: error: asm/suspend.h: No such file or directory
> 
> Caused by commit 8f6404f39725 ("PM / Hibernate: Remove
> arch_prepare_suspend()" which completely removed asm/suspend.h on
> powerpc, frv and s390.
> 
> I have reverted that commit for today.

Thanks for handling that, it should be fixed now.

Rafael
