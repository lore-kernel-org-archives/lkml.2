Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0CaXIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0CaXIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:08:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19891.1270076813@redhat.com>
References: <19891.1270076813@redhat.com> <201003311554.38473.vapier@gentoo.org> <1268151081-28307-1-git-send-email-vapier@gentoo.org> <1261413866-30634-1-git-send-email-vapier@gentoo.org> <14998.1270055484@redhat.com>
Cc: dhowells@redhat.com, Mike Frysinger <vapier@gentoo.org>,
       uclinux-dev@uclinux.org, David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH v2] NOMMU: implement vmap/vunmap with kmalloc
Date: Thu, 01 Apr 2010 00:07:54 +0100
Message-ID: <19923.1270076874@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > how about putting this implementation into like vmap_nommu() and only 
> > rewriting vmap() to vmap_nommu() when we know it's safe ?  such as this 
> > firmware case ?
> 
> Well, I'd argue it's _not_ vmap(), so it doesn't really make sense to call it
> such.  Perhaps some better name?  Perhaps vcopy()?

How about vcoalesce()?

David
