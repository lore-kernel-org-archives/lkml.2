Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2KLM12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:27:28 -0500
Received: from 1wt.eu ([62.212.114.60]:35689 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2KLM10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:27:26 -0500
Date: Mon, 12 Nov 2012 13:26:43 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
Subject: Re: [PATCH v2] menuconfig: Replace CIRCLEQ by list_head-style lists.
Message-ID: <20121112122643.GA9351@1wt.eu>
References: <1350754935-20014-1-git-send-email-benjamin.poirier@gmail.com> <201210222138.25805.yann.morin.1998@free.fr> <50893FCF.5030800@suse.cz> <201211111702.24556.yann.morin.1998@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211111702.24556.yann.morin.1998@free.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 05:02:24PM +0100, Yann E. MORIN wrote:
> Michal, All,
> 
> On Thursday 25 October 2012 Michal Marek wrote:
> > On 22.10.2012 21:38, Yann E. MORIN wrote:
> > > On Sunday 21 October 2012 Benjamin Poirier wrote:
> > >> Changes v1-v2:
> > >> * integrate the patch/suggestion from Yann to fix problems related to the
> > >>   usage of list.h with xconfig/c++
> > >> 	* "new" keyword
> > >> 	* offsetof redefinition
> > >> * silly #endif placement mistake
> [--SNIP--]
> > I pushed it to kbuild.git#rc-fixes now and will send it to Linus for 3.7
> > inclusion later.
> 
> Not trying to sound like a nuisance, but this has still not been pushed
> to Linus yet... ;-)

Would love the patch to be merged too, as I can't build Linux on my Linux
laptop right now, very frustrating :-(

Willy

