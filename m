Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709Ab2FASsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:48:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965617Ab2FASsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:48:06 -0400
Date: Fri, 1 Jun 2012 11:48:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Vladimir =?UTF-8?Q?'=CF=86-coder/phcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 71ca97da9d overrides user's kernel config
Message-Id: <20120601114804.7bd6c2b9.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFyK_m8aO57gC4Q1PJXmY3e1-uRXQ3E6PRgdBVixJSa2gQ@mail.gmail.com>
References: <CA+i8gKK5VJU_0YbBkeav6wTP+5YGp-rd52dTNqyoprz_YZrepA@mail.gmail.com>
	<4FC8E00E.60600@gmail.com>
	<CA+55aFyK_m8aO57gC4Q1PJXmY3e1-uRXQ3E6PRgdBVixJSa2gQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 10:53:20 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Andrew, who would be in charge of "fs/nls"? Almost nobody has really
> touched that area in several years now, and it doesn't have any
> maintainership.

I cc'ed various people on that patch who have had fingers in there in
recent years but no, it doesn't have a maintainer.
