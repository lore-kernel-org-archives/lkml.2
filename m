Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2KIVo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:44:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2KIVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:44:56 -0500
Date: Fri, 9 Nov 2012 13:44:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-11-08-15-17 uploaded (mm/balloon_compaction.c)
In-Reply-To: <509D84C4.4050308@infradead.org>
Message-ID: <alpine.DEB.2.00.1211091344400.2974@chino.kir.corp.google.com>
References: <20121108231753.E6B7A100047@wpzn3.hot.corp.google.com> <509D84C4.4050308@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Randy Dunlap wrote:

> on i386:
> 
> mm/balloon_compaction.c: In function 'balloon_page_putback':
> mm/balloon_compaction.c:243:3: error: implicit declaration of function '__WARN'
> 

Sent a fix for this an hour ago: 
http://marc.info/?l=linux-kernel&m=135249681031225
