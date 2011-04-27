Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1D0IWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:22:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60553 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1D0IW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:22:28 -0400
Date: Wed, 27 Apr 2011 10:22:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
Message-ID: <20110427082226.GB5726@merkur.ravnborg.org>
References: <20110422110947.GA20715@merkur.ravnborg.org> <1303494642-18594-1-git-send-email-bp@alien8.de> <4DB72283.5000108@suse.cz> <20110426204307.GA15315@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426204307.GA15315@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:43:07PM +0200, Borislav Petkov wrote:
> On Tue, Apr 26, 2011 at 09:52:35PM +0200, Michal Marek wrote:
> > On 22.4.2011 19:50, Borislav Petkov wrote:
> > > From: Sam Ravnborg <sam@ravnborg.org>
> > > 
> > > Building a kernel with "make W=1" produce far too much noise
> > > to be usefull.
> > > 
> > > Divide the warning options in three groups:
> > > 
> > >     W=1 - warnings that may be relevant and does not occur too often
> > >     W=2 - warnings that occur quite often but may still be relevant
> > >     W=3 - the more obscure warnings, can most likely be ignored
> > > 
> > > When building init/ on my box the levels produces:
> > > 
> > > W=1 - 46 warnings
> > > W=2 - 863 warnings
> > > W=3 - 6496 warnings
> > 
> > I guess these numbers are not valid after your changes? Not that the
> > exact numbers are important, but maybe the distribution change?
> 
> I think so too that those numbers don't mean a lot.

The numbers _only_ tell you that the amoun of warnings on W=1
is down to a manageable number and they increase be the higher
level.

Will you cook up a more correct changelog and resubmit?

	Sam
