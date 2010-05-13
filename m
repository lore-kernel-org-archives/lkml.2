Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0EMFSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:18:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0EMFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:18:37 -0400
Message-ID: <4BEB8BA9.5070001@infradead.org>
Date: Thu, 13 May 2010 02:18:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the v4l-dvb tree
References: <20100513130016.25b76c3f.sfr@canb.auug.org.au>
In-Reply-To: <20100513130016.25b76c3f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree produced a mountain of
> conflicts so I have used the version from next-20100512 for today.
> Please either merge Linus' tree into yours or rebase you tree on top of
> Linus' tree.  There are a large number of commits that are in your tree
> that have been rebased before being included into Linus' tree and this
> caused conflicts with further changes in your tree.

I'll be pulling from Linus on my tree. I did it yesterday, after my last changes,
but it seems that I've made a huge mistake... Several conflicts that I've already
fixed reappeared. I suspect that I've merged it with an older temporary branch
by mistake.

Anyway, it is fixed, by simply going back to the last reflog before the error,
and re-merging the new patches again. A pull from Linus didn't show any conflict.

So, it should be now OK for you to merge.

> Please consider changing your work flow so that you don't rebase things
> in your tree before sending them to Linus.

I'm already in process of changing my procedure. The problem is that I didn't find
yet a perfect way to handle my tree. I'm getting some new ideas, and intend to implement
them for 2.6.35 development cycle (linux-next for 2.6.36).

-- 

Cheers,
Mauro
