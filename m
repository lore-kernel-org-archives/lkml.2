Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622Ab0HGLJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:09:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:59974 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0HGLJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:09:42 -0400
Message-ID: <4C5D3EEF.2080806@windriver.com>
Date: Sat, 07 Aug 2010 06:09:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build error after merge of the kgdb tree
References: <20100807142122.a305ed8a.sfr@canb.auug.org.au>
In-Reply-To: <20100807142122.a305ed8a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2010 11:09:37.0001 (UTC) FILETIME=[05D75590:01CB3621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 11:21 PM, Stephen Rothwell wrote:
> Hi Jason,
>
> After merging the kgdb tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this error (and hundreds of similar
> errors/warnings):
>
> In file included from include/linux/rculist.h:10,
>                  from include/linux/dcache.h:6,
>                  from include/linux/fs.h:375,
>                  from include/linux/security.h:25,
>                  from security/min_addr.c:3:
> include/linux/rcupdate.h:606: warning: function declaration isn't a prototype
>
>   

I removed the kgdb rcu stall detector patches from the queue until they
are re-worked against the latest rcu changes pending in linux-next.

Thanks,
Jason.
