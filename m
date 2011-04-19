Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1DSCki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:40:38 -0400
Received: from linux-sh.org ([111.68.239.195]:55472 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab1DSCkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:40:37 -0400
Date: Tue, 19 Apr 2011 11:40:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Prokop <mika@grml.org>
Subject: Re: [PATCH] Documentation/dontdiff: large update
Message-ID: <20110419024030.GA28271@linux-sh.org>
References: <20110418160809.f10c0b62.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418160809.f10c0b62.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 04:08:09PM -0700, Randy Dunlap wrote:
> -int16.c
> -int1.c
> -int2.c
> -int32.c
> -int4.c
> -int8.c
> +int*.c

int[0-9]*.c or something might make sense, but this is going to trip up a
lot of intel and interrupt related files.

> +lib1funcs.S

This is also bogus. The one place it's used in a .gitignore in the kernel
is a special case, while you obviously don't want to ignore it in the
arch/foo/lib/ case.
