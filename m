Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0FAM32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:29:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab0FAM31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:29:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTiltnomEArb1bPTYuNI_HpK6oN_gv-VAII9db3n8@mail.gmail.com>
References: <AANLkTiltnomEArb1bPTYuNI_HpK6oN_gv-VAII9db3n8@mail.gmail.com> <20100528165659.1e6fd136.yoshikawa.takuya@oss.ntt.co.jp>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       d.hatayama@jp.fujitsu.com, lethal@linux-sh.org,
       takuya.yoshikawa@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: fix clear_user() error handling
Date: Tue, 01 Jun 2010 13:29:01 +0100
Message-ID: <29627.1275395341@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> on nommu systems, this is generally not an issue because clear_user()
> is basically a memset().  but it's good to handle every case.

But FDPIC is used on MMU systems too.

David
