Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161390Ab2CPOkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161069Ab2CPOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:40:15 -0400
Subject: Re: [PATCH 05/38] Disintegrate asm/system.h for ARM [ver #3]
From: Mark Salter <msalter@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 16 Mar 2012 10:40:06 -0400
In-Reply-To: <20120315205603.28759.91855.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
	 <20120315205603.28759.91855.stgit@warthog.procyon.org.uk>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Message-ID: <1331908808.12353.2.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 20:56 +0000, David Howells wrote:
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-arm-kernel@lists.infradead.org
> ---

<snip>

> diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
> index 94e924e..d9072d9 100644
> --- a/include/linux/mtd/map.h
> +++ b/include/linux/mtd/map.h
> @@ -1,4 +1,4 @@
> -/*
> + r/*
>   * Copyright © 2000-2010 David Woodhouse <dwmw2@infradead.org> et al.
>   *
>   * This program is free software; you can redistribute it and/or modify
> 

Looks like this hunk was unintended. It is causing a build failure for
me.

--Mark


