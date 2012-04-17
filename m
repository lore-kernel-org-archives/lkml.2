Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2DQRgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2DQRgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:36:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333195293-5081-1-git-send-email-consul.kautuk@gmail.com>
References: <1333195293-5081-1-git-send-email-consul.kautuk@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: dhowells@redhat.com, Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/19 v2] mn10300/mm/fault.c: Port OOM changes to do_page_fault
Date: Tue, 17 Apr 2012 18:36:19 +0100
Message-ID: <6294.1334684179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kautuk Consul <consul.kautuk@gmail.com> wrote:

> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
> 
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
> 
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
> 
> Port these changes to mn10300.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
