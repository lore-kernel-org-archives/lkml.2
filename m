Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2HMRF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:05:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50545 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2HMRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:05:27 -0400
Date: Mon, 13 Aug 2012 10:05:22 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] workqueue: use system_highpri_wq for highpri
 workers in rebind_workers()
Message-ID: <20120813170522.GG9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-4-git-send-email-js1304@gmail.com>
 <20120813163452.GB9180@google.com>
 <CAAmzW4P23=XDd6r1cJmz4R8Q4wotyhGx-6u=B=cmMofUj36Bng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4P23=XDd6r1cJmz4R8Q4wotyhGx-6u=B=cmMofUj36Bng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:57:10AM +0900, JoonSoo Kim wrote:
> > I think it would be better to just opencode system_wq selection in
> > rebind_workers().
> 
> Sorry for my poor English skill.
> Could you elaborate "opencode system_wq selection" means?

Dropping get_pool_system_wq() and putting the logic inside
rebind_workers() directly.  I tend to dislike short helpers which are
used only once.  They tend to obfuscate while not really contributing
to anything else.

Thanks.

-- 
tejun
