Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab2JIRRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:17:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39059 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2JIRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:17:06 -0400
Date: Tue, 09 Oct 2012 13:17:04 -0400 (EDT)
Message-Id: <20121009.131704.983863129128480075.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for net
From: David Miller <davem@davemloft.net>
In-Reply-To: <30725.1349789433@warthog.procyon.org.uk>
References: <30725.1349789433@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 09 Oct 2012 14:30:33 +0100

> Can you merge the following branch into the net tree please.
> 
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
> 
> 	include/uapi/linux/.../foo.h
> 
> for the userspace interface stuff, and:
> 
> 	include/linux/.../foo.h
> 
> for the strictly kernel internal stuff.
> 
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-net-20121009

Ok I pulled this and the ISDN one too.

Thanks.
