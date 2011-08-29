Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1H2Sf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:35:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57354 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246Ab1H2Sf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:35:27 -0400
Subject: Re: RFC: dynamic debug enhancements?
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJfuBxwFvRvy=umR-C1S8+pawQ8HtD_m-X5zAQ0cTBpCkpWcHA@mail.gmail.com>
References: <1313972143.11178.55.camel@Joe-Laptop>
	 <20110823142311.GB2526@redhat.com> <1314147605.1659.40.camel@Joe-Laptop>
	 <CAJfuBxwFvRvy=umR-C1S8+pawQ8HtD_m-X5zAQ0cTBpCkpWcHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 11:35:26 -0700
Message-ID: <1314642926.6852.26.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 12:21 -0600, Jim Cromie wrote:
> how about just passing in condition directly ?
> #define pr_dbg_if( cond, fmt, ... )                  \
> do {                                                        \
>     if (cond)                \
>             pr_debug(fmt, ##__VA_ARGS__);           \
> } while (0)
> this will serve both mask and level, and could underlie both of them,
> and its clear - no hidden checks against a variable named elsewhere.

The idea is to let dynamic debug control the
output for the various mask/level tests.

That could get out of sync with pr_debug.

It separates the pr_debug condition from the test.


