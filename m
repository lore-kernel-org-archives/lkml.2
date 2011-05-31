Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab1EaUET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:04:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1EaUES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:04:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Date: Tue, 31 May 2011 22:04:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4DE3E9E7.8020008@zytor.com> <20110531194358.GA4424@elf.ucw.cz>
In-Reply-To: <20110531194358.GA4424@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105312204.02722.arnd@arndb.de>
X-Provags-ID: V02:K0:WEdUF2/kJM4XNSpdxmausPjQnTtPBPR1r4xNhhtKZG/
 T0ORykuAlZkQ900q7bRjDdclJa+9X7WCFTLWElQuJk4mbbPXj5
 iWegQzk7D1ze8LAfKUbDKyia+zH0JMGHfgCMqZgtKgBVHR22mA
 EqMIZ45KuiUA/jv0nyCbTYgh6Jz8VqkyfOj75gBMoLrxTApxZi
 cUWsrFVJQGONE+2rm6Mww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 May 2011 21:43:59 Pavel Machek wrote:
> > With the v3.0 name change I was looking over what might break, and I'm
> > seriously considering turning off the incremental diff robot on
> > kernel.org.  It's not clear to me that it is actually useful anymore,
> > with git and all.

Are you talking about just ftp://ftp.kernel.org/pub/linux/kernel/*/incr/
or also about ftp://ftp.kernel.org/pub/linux/kernel/v2.6/patch-* and
Changelog-*?

I can see reasons to keep the latter, but not necessarily the former.

> > Do anyone actually use these anymore?
> 
> Yes.
> 
> Usecase one is zaurus, which is just not powerful enough for git, and
> usecase two are companies that only work with releases... ketchup is
> very useful for both.

For usecase one, is it possible to replace the download links with
links into http://git.kernel.org/ ?

For usecase two, why wouldn't those be able to just download the entire
release tarball? At least, I would expect that there is no need for
the small incremental patches in their case, only for the full
inter-release patches.

	Arnd
