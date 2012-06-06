Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2FFPf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:35:27 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16922 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FFPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:35:26 -0400
Date: Wed, 6 Jun 2012 17:35:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
Message-ID: <20120606153521.GA30811@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org> <1336205926-13946-7-git-send-email-sam@ravnborg.org> <1338977927.6875.29.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338977927.6875.29.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 01:18:47PM +0300, Artem Bityutskiy wrote:
> On Sat, 2012-05-05 at 10:18 +0200, Sam Ravnborg wrote:
> > Prevent that we eveluate cc-option multiple times for the same
> > option by moving the definitions to Kbuild.arch.
> > The file is included once only, thus gcc is not invoked once per directory.
> > 
> > Another side-effect of this patch is that KCFLAGS are appended last
> > to the list of options. This allows us to better control the options.
> > Artem Bityutskiy <dedekind1@gmail.com> noticed this.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Artem Bityutskiy <dedekind1@gmail.com>
> 
> Hi,
> 
> what happened to this patch? I was fixing the real issue I am
> encountering and I thought it'd be taken instead of my original patch.
We decided to move this to next merge release because is was not added
to kbuild thus not enough exposure in -next.

I am planning to resend the serie at around -rc2 time.

	Sam
