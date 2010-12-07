Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0LGO2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:28:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33841 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0LGO2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:28:12 -0500
Date: Tue, 7 Dec 2010 08:27:47 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Containers <containers@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] user_ns: Improve the user_ns on-the-slab packaging
Message-ID: <20101207142747.GB4674@hallyn.com>
References: <4CFE40D1.5000309@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFE40D1.5000309@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@parallels.com):
> Currently on 64-bit arch the user_namespace is 2096 and when
> being kmalloc-ed it resides on a 4k slab wasting 2003 bytes.
> 
> If we allocate a separate cache for it and reduce the hash size
> from 128 to 64 chains the packaging becomes *much* better - the

Hey Pavel,

I trust you've done some performance tests and found no
regressions with a few hundred users?

-serge
