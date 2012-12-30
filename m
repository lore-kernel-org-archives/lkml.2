Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2L3Jky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 04:40:54 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2L3Jkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 04:40:52 -0500
Date: Sun, 30 Dec 2012 10:40:43 +0100
From: Richard Weinberger <richard@nod.at>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Jeff Dike <jdike@addtoit.com>,
        Martin =?UTF-8?B?UMOkcnRlbA==?= <martin.partel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] um: fix build failure due to mess-up of sig_info
 protorype
Message-ID: <20121230104043.2090940b@spider.haslach.nod.at>
In-Reply-To: <1356820651-8495-2-git-send-email-slyfox@gentoo.org>
References: <1356820651-8495-1-git-send-email-slyfox@gentoo.org>
	<1356820651-8495-2-git-send-email-slyfox@gentoo.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 30 Dec 2012 01:37:31 +0300
schrieb Sergei Trofimovich <slyfox@gentoo.org>:

> arch/um/os-Linux/signal.c:18:8: error: conflicting types for
> 'sig_info' In file included
> from /home/slyfox/linux-2.6/arch/um/os-Linux/signal.c:12:0:
> arch/um/include/shared/as-layout.h:64:15: note: previous declaration
> of 'sig_info' was here
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> CC: Jeff Dike <jdike@addtoit.com>
> CC: Richard Weinberger <richard@nod.at>
> CC: "Martin Pärtel" <martin.partel@gmail.com>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: user-mode-linux-devel@lists.sourceforge.net
> CC: user-mode-linux-user@lists.sourceforge.net
> CC: linux-kernel@vger.kernel.org
> ---

I think both patches need to be backported to -stable.
I'll add the tag and push the patches ASAP to Linus.

Thanks,
//richard
