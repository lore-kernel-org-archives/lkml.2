Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2EUTs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:48:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2EUTs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:48:58 -0400
Date: Mon, 21 May 2012 15:48:52 -0400 (EDT)
Message-Id: <20120521.154852.2281965083131461050.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: sam@ravnborg.org, netdev@vger.kernel.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: drop NET dependency from HAVE_BPF_JIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwo6XusR8pNY+dp_5uFNqCxZjeWWL6h+V=PFqT884Qc_A@mail.gmail.com>
References: <CA+55aFy4He9X6wQjATaJukzH1FkyhGqnmC4kb+azKuMmjPGbmg@mail.gmail.com>
	<20120521185202.GA6486@merkur.ravnborg.org>
	<CA+55aFwo6XusR8pNY+dp_5uFNqCxZjeWWL6h+V=PFqT884Qc_A@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 May 2012 12:48:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 11:54:00 -0700

> On Mon, May 21, 2012 at 11:52 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> Fix up all users to drop the dependency on NET now that
>> it is not required to supress warnings for non-NET builds.
> 
> Do you want me to take this directly, or will it go through the net
> tree? I can live with it either way.

Linus, please take it directly, Sam's change looks great.
