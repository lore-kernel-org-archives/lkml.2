Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0GTG7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:59:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47458 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0GTG7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:59:31 -0400
Date: Tue, 20 Jul 2010 08:59:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kees Bakker <kees.bakker@xs4all.nl>, Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] documentation: fix almost duplicate filenames
 (io/IO-mapping.txt)
Message-ID: <20100720065925.GB16367@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Kees Bakker <kees.bakker@xs4all.nl>,
	Keith Packard <keithp@keithp.com>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
 <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
 <20100719220545.098cb7aa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100719220545.098cb7aa.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, Jul 19, 2010 at 10:05:45PM -0700

> On Mon, 19 Jul 2010 19:27:13 -0700 Linus Torvalds wrote:
> 
> > On Mon, Jul 19, 2010 at 6:12 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > >
> > > (hopefully I got this right.  I'm not a big git user.)
> > 
> > Hmm. No.
> > 
> > The commit otherwise looks correct, but the commit message is
> > buggered. The first line of the message is
> > 
> >    From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > rather than the subject of the patch itself.
> > 
> > No fear. Practice makes perfect. Just try again ;)
> 
> 
> Will do... but how do I edit the commit message?

git commit --amend

after you've made sure that the commit you want to edit is at the tip of
the current branch.

-- 
Regards/Gruss,
    Boris.
