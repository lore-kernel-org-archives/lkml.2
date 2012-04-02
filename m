Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2DBFui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2DBFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:50:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-7-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-7-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 06/11] parisc: fix missing cmpxchg file error from system.h split
Date: Mon, 02 Apr 2012 06:50:23 +0100
Message-ID: <30153.1333345823@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Commit b4816afa3986704d1404fc48e931da5135820472
> 
>     "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"
> 
> introduced the concept of asm/cmpxchg.h but the parisc arch
> never got one.  Fork the cmpxchg content out of the asm/atomic.h
> file to create one.
> 
> Some minor whitespace fixups were done on the block of code that
> created the new file.
> 
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
