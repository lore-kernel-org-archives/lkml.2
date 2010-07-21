Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab0GUId1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:33:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:39753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762814Ab0GUIdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:33:22 -0400
Date: Wed, 21 Jul 2010 10:33:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/139] update web addresses. 
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1007211030380.4741@pobox.suse.cz>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, Justin P. Mattock wrote:

> I clearly have too much time on my hands.. 
> Anyways I went through as much as possible and tried to update all the
> web addresses that are broken in Documentation to the best as possible. 
> 
> 
> Some addresses just had a change in name and ended up being a quick fix,
> but other addresses ended up(maybe)removing the spec altogether form there
> site. In this case I just put a direct link to the company itself
> (if somebody finds the link please send me a post).
> 
> For the addresses that I could not find through searching, I ended up just 
> removing altogether(some where as far back as 1995/99) if anybody knows
> the location please let me know and/or send a fix so the kernel can be updated
> as best as possible. 
> 
> In any case hope it's good if not I'll resend..main thing is I've located
> the broken links that need updateing.

Thanks for doing the deadly boring stuff. Makes one wonder whether having 
the URLs in kernel at all is worth it ...

Having it in separate patches makes probably some sense for the first 
round, so that affected people might look into it separately and comment 
on the updates (unfortunately, you haven't CCed respective maintainers on 
individual patches, which would be good thing to do).

But once you collect all the feedback and it's ready to be merged, please 
send it to me just as a one single patch. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
