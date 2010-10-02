Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab0JBEPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 00:15:54 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:60697 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab0JBEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 00:15:52 -0400
Date: Fri, 1 Oct 2010 21:14:09 -0700
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: correct variable definitions in
 makefiles.txt
Message-ID: <20101002041409.GA6370@haskell.muteddisk.com>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	Sam Ravnborg <sam@ravnborg.org>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1284964412-32211-1-git-send-email-mfm@muteddisk.com>
 <4CA35541.9090106@suse.cz>
 <20100929175031.GA9278@merkur.ravnborg.org>
 <20100929231904.GB21930@haskell.muteddisk.com>
 <20101001205646.GA10988@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001205646.GA10988@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:56 Fri 01 Oct     , Michal Marek wrote:
> On Wed, Sep 29, 2010 at 04:19:04PM -0700, matt mooney wrote:
> > On 19:50 Wed 29 Sep     , Sam Ravnborg wrote:
> > > On Wed, Sep 29, 2010 at 05:03:29PM +0200, Michal Marek wrote:
> > > > On 20.9.2010 08:33, matt mooney wrote:
> > > > > Change $(src) and $(obj) definitions to state the path as absolute and
> > > > > not relative.
> > > > 
> > > > It _is_ a relative patch, AFAICS. What makes you think otherwise?
> > > 
> > > With extenal modules $(src) and $(obj) are absolute - but in nomal
> > > use they are relative.
> 
> Ah, I see. Then we should simply say "path", without any adjectives.

That may lead to people wondering what kind of path it is, or assumptions that
it is absolute due to being stated as such in modules.txt. Maybe a more detailed
explanation would suffice.

-mfm
