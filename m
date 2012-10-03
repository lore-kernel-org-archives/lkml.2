Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2JCFMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:12:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54150 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2JCFMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:12:46 -0400
Date: Tue, 2 Oct 2012 22:12:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Joe Perches <joe@perches.com>,
        Kautuk Consul <consul.kautuk@gmail.com>, linux-mm@kvack.org,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] mm: use %pK for /proc/vmallocinfo
In-Reply-To: <20121002234934.GA9194@www.outflux.net>
Message-ID: <alpine.DEB.2.00.1210022209070.9523@chino.kir.corp.google.com>
References: <20121002234934.GA9194@www.outflux.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Kees Cook wrote:

> In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
> virtual addresses in /proc/vmallocinfo too.
> 
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

/proc/vmallocinfo is S_IRUSR, not S_IRUGO, so exactly what are you trying 
to protect?
