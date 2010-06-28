Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0F1Mtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0F1Mtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:49:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277621246-10960-5-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-5-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
       lenb@kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 4/5]block:cryptoloop Fix warning: variable 'cipher' set but not used
Date: Mon, 28 Jun 2010 13:49:12 +0100
Message-ID: <7245.1277729352@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> Im getting this when compiling on gcc 4.6.0
>   CC [M]  drivers/block/cryptoloop.o
> drivers/block/cryptoloop.c: In function 'cryptoloop_init':
> drivers/block/cryptoloop.c:46:8: warning: variable 'cipher' set but not used
> The below fixes it for me. Please have a look and let me know.
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
