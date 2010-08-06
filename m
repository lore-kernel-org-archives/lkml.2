Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246Ab0HFC1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:27:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935156Ab0HFC1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:27:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100806014057.GA22395@gondor.apana.org.au>
References: <20100806014057.GA22395@gondor.apana.org.au> <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: dhowells@redhat.com, torvalds@osdl.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr problem
Date: Fri, 06 Aug 2010 03:27:25 +0100
Message-ID: <14347.1281061645@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.hengli.com.au> wrote:

> This patch should do the trick:
> 
> commit 326a6346ffb5b19eb593530d9d3096d409e46f62
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Aug 6 09:40:28 2010 +0800
> 
>     crypto: testmgr - Fix test disabling option

It does work.

David
