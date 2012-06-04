Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2FDUlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:41:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52664 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2FDUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <87ipf71ytx.fsf@rustcorp.com.au>
References: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com> <87ipf71ytx.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Jun 2012 13:39:27 -0700
X-Google-Sender-Auth: LqEo_U_FhmqvAosatWR2ZwbBBec
Message-ID: <CA+55aFwJj5t6zS_pgD3kMemRWkUkSoWWHey84pJegSRfnzXNzA@mail.gmail.com>
Subject: Re: init: multi param parsing regression since 3.4
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 9:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Subject: module_param: stop double-calling parameters.
> From: Rusty Russell <rusty@rustcorp.com.au>

Rusy, should I take this (with the ubi/build.c part removed) from the
email - along with the initcall debug printk removals - or can I just
expect to get a pull request with these things?

                Linus
