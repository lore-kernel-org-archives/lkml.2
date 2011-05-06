Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1EFSPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:15:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1EFSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:15:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (suspend tree related)
Date: Fri, 6 May 2011 20:15:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110506135345.a885d08a.sfr@canb.auug.org.au>
In-Reply-To: <20110506135345.a885d08a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105062015.43024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 06, 2011, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> drivers/built-in.o: In function `_request_firmware':
> firmware_class.c:(.text+0x385c8): undefined reference to `usermodehelper_is_disabled'
> 
> Caused by commit 3e61c4dd3e1e ("PM: Print a warning if firmware is
> requested when tasks are frozen").  usermodehelper_is_disabled is only
> defined if CONFIG_PM_SLEEP is set.
> 
> I have reverted that commit for today.

Should be fixed now, sorry for the trouble.

Thanks,
Rafael
