Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0KWJon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:44:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38576 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab0KWJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:44:42 -0500
MIME-Version: 1.0
In-Reply-To: <1290501502.2390.7029.camel@nimitz>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
Date: Tue, 23 Nov 2010 10:44:42 +0100
Message-ID: <AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: =?UTF-8?Q?Peter_Sch=C3=BCller?= <scode@spotify.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't have anybody messing with /proc/sys/vm/drop_caches, do you?

Highly unlikely given that (1) evictions, while often very
significant, are usually not *complete* (although the first graph
example I provided had a more or less complete eviction) and (2) the
evictions are not obviously periodic indicating some kind of cron job,
and (3) we see the evictions happening across a wide variety of
machines.

So yes, I feel confident that we are not accidentally doing that.

(FWIW though, drop_caches is great. I only recently found out about
it, and it's really useful when benchmarking.)

-- 
/ Peter Schuller aka scode
