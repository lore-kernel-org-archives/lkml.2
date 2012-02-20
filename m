Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2BTVMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2BTVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:12:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1328677745-20121-8-git-send-email-hpa@zytor.com>
References: <1328677745-20121-8-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 07/21] frv: Use generic posix_types.h
Date: Mon, 20 Feb 2012 21:12:49 +0000
Message-ID: <14108.1329772369@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Change the frv architecture to use <asm-generic/posix_types.h>.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Acked-by: David Howells <dhowells@redhat.com>
