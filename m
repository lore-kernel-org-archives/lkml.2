Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2DBFxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2DBFw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:52:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-11-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-11-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 10/11] tile: fix multiple build failures from system.h dismantle
Date: Mon, 02 Apr 2012 06:52:49 +0100
Message-ID: <30198.1333345969@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Commit bd119c69239322caafdb64517a806037d0d0c70a
> 
>     "Disintegrate asm/system.h for Tile"
> 
> created the asm/switch_to.h file, but did not add an include
> of it to all its users.
> 
> Also, commit b4816afa3986704d1404fc48e931da5135820472
> 
>         "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"
> 
> introduced the concept of asm/cmpxchg.h but the tile arch
> never got one.  Fork the cmpxchg content out of the asm/atomic.h
> file to create one.
> 
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
