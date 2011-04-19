Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1DSBXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:23:00 -0400
Received: from mail.perches.com ([173.55.12.10]:4829 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab1DSBW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:22:59 -0400
Subject: Re: [PATCH] Documentation/dontdiff: large update
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Prokop <mika@grml.org>
In-Reply-To: <20110418160809.f10c0b62.rdunlap@xenotime.net>
References: <20110418160809.f10c0b62.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 18:22:57 -0700
Message-ID: <1303176177.31723.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 16:08 -0700, Randy Dunlap wrote:
> Update to Documentation/dontdiff, based on many updates to
> various .gitignore patches over the last 2 years.
[]
> --- lnx-2639-r3g8-dontdiff.orig/Documentation/dontdiff
> +++ lnx-2639-r3g8-dontdiff/Documentation/dontdiff
[]
> -int16.c
> -int1.c
> -int2.c
> -int32.c
> -int4.c
> -int8.c
> +int*.c

Is this really a good idea?

$ find -name "int*.c" | wc -l
115


