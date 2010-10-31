Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab0JaEUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 00:20:30 -0400
Received: from mail.perches.com ([173.55.12.10]:3875 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0JaEU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 00:20:29 -0400
Subject: Re: [PATCH 1/2] kernel/module.c: Use pr_<level> and pr_fmt
From: Joe Perches <joe@perches.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <AANLkTiniij6Xyq77mrm_FiuNfd4ggA+qHx6__6sfS_i_@mail.gmail.com>
References: <cover.1288482645.git.joe@perches.com>
	 <c913cbdfddab78a4b7c840e0d8ff9754c306fc66.1288482645.git.joe@perches.com>
	 <AANLkTiniij6Xyq77mrm_FiuNfd4ggA+qHx6__6sfS_i_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 21:20:27 -0700
Message-ID: <1288498827.366.183.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 00:04 -0400, Arnaud Lacombe wrote:
> [not that I'm fond of getting my mailbox full of whitespace patches, but...]
> On Sat, Oct 30, 2010 at 7:58 PM, Joe Perches <joe@perches.com> wrote:
> > Add missing KERN_CONT to printks
> > Convert to pr_<level>
> > Add "#define pr_fmt(fmt) fmt" so pr_<level> uses are not prefixed.
> > Coalesce long formats for easier grep.

Mostly it's a way to add #define pr_fmt(fmt) fmt
in this file so that a different default for
pr_fmt could be used in kernel.h later.

This patch was sent to lkml and not directly
to you.  As you find this stuff uninteresting I
suggest you unsubscribe and read LKML using any
of the various web services like lkml.org and
read only what you find useful.


