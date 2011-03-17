Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1CQLc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:32:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab1CQLc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:32:57 -0400
Date: Thu, 17 Mar 2011 12:32:55 +0100
From: Michal Marek <mmarek@suse.cz>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KBuild: silence "'scripts/unifdef' is up to date."
Message-ID: <20110317113255.GA28330@sepie.suse.cz>
References: <20110315063425.9538.11565.stgit@mike.mtv.corp.google.com>
 <ilnq8l$rjj$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ilnq8l$rjj$1@dough.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 01:40:37PM +0000, WANG Cong wrote:
> On Mon, 14 Mar 2011 23:34:25 -0700, Mike Waychison wrote:
> 
> > Patch applies to 2.6.38-rc8.
> > 
> > While changing our build system over to use the headers_install target
> > as part of our klibc build, the following message started showing up in
> > our logs:
> > 
> > make[2]: `scripts/unifdef' is up to date.
> > 
> > It turns out that the build blindly invokes a recursive make on this
> > target, which causes make to emit this message when the target is
> > already up to date.  This isn't seen for most targets as the rest of the
> > build relies primarily on the default target and on PHONY targets when
> > invoking make recursively.
> > 
> > Silence the above message when building unifdef as part of
> > headers_install by hiding it behind a new PHONY target called
> > "build_unifdef" that has an empty recipe.
> > 
> > Signed-off-by: Mike Waychison <mikew@google.com> ---
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
