Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966588Ab2FBLYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937Ab2FBLYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:24:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1338635319-28226-1-git-send-email-geert@linux-m68k.org>
References: <1338635319-28226-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: Remove bogus closing parenthesis
Date: Sat, 02 Jun 2012 12:24:31 +0100
Message-ID: <4994.1338636271@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Introduced by commit 6fd84c0831ec78d98736b76dc5e9b849f1dbfc9e
> ("TIF_RESTORE_SIGMASK can be set only when TIF_SIGPENDING is set")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: David Howells <dhowells@redhat.com>
