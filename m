Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2BTVMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2BTVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:12:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1328677745-20121-14-git-send-email-hpa@zytor.com>
References: <1328677745-20121-14-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 13/21] mn10300: Use generic posix_types.h
Date: Mon, 20 Feb 2012 21:12:03 +0000
Message-ID: <14069.1329772323@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Change the mn10300 architecture to use <asm-generic/posix_types.h>.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

The deletion of part of the user API does not appear to cause a problem.

Acked-by: David Howells <dhowells@redhat.com>
