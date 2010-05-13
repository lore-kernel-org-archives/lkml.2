Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0EMKBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068Ab0EMKBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:01:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100512163907.c67c08ab.akpm@linux-foundation.org>
References: <20100512163907.c67c08ab.akpm@linux-foundation.org> <20100510225959.GC12203@kryten>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Anton Blanchard <anton@samba.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Call console_verbose in panic
Date: Thu, 13 May 2010 11:00:20 +0100
Message-ID: <1990.1273744820@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> The sole caller of console_silent() is
> arch/mn10300/kernel/mn10300-watchdog.c:watchdog_interrupt(), which
> makes me wonder if mn10300 is doing something wrong or outdated?

The MN10300 code will have been copied from elsewhere, so it may well be
outdated.

David
