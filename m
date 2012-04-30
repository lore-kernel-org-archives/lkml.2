Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2D3JJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab2D3JJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:09:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: dhowells@redhat.com, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
Date: Mon, 30 Apr 2012 10:08:57 +0100
Message-ID: <21326.1335776937@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> wrote:

> Make get_current() into a static inline function in the
> generic version of current.h so we match what almost every
> architecture is doing. This allows us to move most of the arches
> over to this generic header instead of redefining the same thing
> over and over in each asm directory.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arch@vger.kernel.org

Acked-by: David Howells <dhowells@redhat.com> [MN10300]
