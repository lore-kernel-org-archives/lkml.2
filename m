Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1EEJHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:07:30 -0400
Received: from vostochny.stro.at ([78.47.22.85]:37334 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1EEJH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:07:29 -0400
Date: Thu, 5 May 2011 09:07:28 +0000
From: maximilian attems <max@stro.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Nuno Subtil <subtil@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
Message-ID: <20110505090728.GC30678@vostochny.stro.at>
References: <1304488750-13606-1-git-send-email-subtil@gmail.com>
 <20110504204807.GB13293@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504204807.GB13293@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 10:48:07PM +0200, Michal Marek wrote:
> Adding Maks to CC.

thanks, this one looks, good please disguard the other patch.
 
> On Tue, May 03, 2011 at 10:59:10PM -0700, Nuno Subtil wrote:
> > When generating the header package, scripts/package/builddeb was inferring the
> > target architecture by looking at the output of dpkg --print-architecture. This
> > allows KBUILD_DEBARCH to override that.
> > 
> > Signed-off-by: Nuno Subtil <subtil@gmail.com>
Acked-by: maximilian attems <max@stro.at>
