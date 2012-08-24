Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2HXPuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:50:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759649Ab2HXPt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:49:59 -0400
Date: Fri, 24 Aug 2012 17:49:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH v2 0/6] menuconfig: jump to search results
Message-ID: <20120824154957.GA5738@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Benjamin Poirier <bpoirier@suse.de>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Jean Sacren <sakiwit@gmail.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Cheng Renquan <crquan@gmail.com>
References: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:55:02PM -0400, Benjamin Poirier wrote:
> This patch series adds "jump to" keys (similar to the cscope interface) to the
> search results of "make menuconfig" so that we can go directly to the menu
> entry for a config option after searching for it.
> 
> Patches 1-4 implement the basic functionality.
> Patches 5-6 are an optional improvement.
> 
> Changes v1-v2:
> * add a short description to patches 2 & 3
> * correct checkpatch style warnings on patch 6
> 
> It should be targeted for v3.7

Ok, did a quick test on -rc3 here. Is it a feature that if I do a
search, go to the result, then do a search again and go to another
result from the second search... and do that a couple of times, clicking
on Exit at the lower part of the menu returns me back to all the
searches I had done? Much like a stack.

I mean, I don't mind it that way, it is workable - I'm just asking :).

Thanks.

-- 
Regards/Gruss,
Boris.
