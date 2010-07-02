Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0GBUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:43:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0GBUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:43:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Break out types from <linux/list.h> to <linux/list_types.h>.
Date: Fri, 2 Jul 2010 22:43:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <201007021811.04197.arnd@arndb.de> <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com> <20100702191910.GA5842@parisc-linux.org>
In-Reply-To: <20100702191910.GA5842@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007022243.13270.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aJWT0F+fV2EmLHCLIXcAZWF7auPLB7cfs/su
 steTEezjuOQ1/ENHPSm56LSkA01MYm6g3US9qwAbspcuH6E8Gg
 39TkhzSf7us4iuc3bxgmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 21:19:11 Matthew Wilcox wrote:
> Why a new header file instead of linux/types.h?

I think it mostly makes sense because a list_head by itself usually
isn't all that useful, you also want the list_add/list_for_each/...
macros, so you end up including linux/list.h anyway.

linux/list_types.h is really a special case which can get included
by other headers when they have a reason for doing that.

	Arnd
