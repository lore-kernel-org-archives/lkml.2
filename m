Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2G3UWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:22:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab2G3UWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:22:21 -0400
Date: Mon, 30 Jul 2012 16:22:12 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Message-ID: <20120730202212.GA31790@d2.synalogic.ca>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
 <20120730195826.GA8242@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730195826.GA8242@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/07/30 21:58, Borislav Petkov wrote:
> On Mon, Jul 30, 2012 at 03:22:04PM -0400, Benjamin Poirier wrote:
> > Hello,
> > 
> > This patch series adds "jump to" keys (similar to the cscope interface) to the
> > search results of "make menuconfig" so that we can go directly to the menu
> > entry for a config option after searching for it.
> > 
> > Patches 1-4 implement the basic functionnality.
> > Patches 5-6 are an optionnal improvement.
> 
> Generally,
> 
> a nice idea, I like it.
> 
> A couple of notes though:
> 
> * patches 2/6 and 3/6 don't have commit messages and it would be good if
> they had, even though it is obvious what the changes in there do.
> 
> * this patchset must be against some kbuild tree because it doesn't
> apply against 3.5:

It's against linux-next, which already contains some patches for
menuconfig.
