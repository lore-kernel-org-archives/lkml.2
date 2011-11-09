Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1KIIrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:47:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46831 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab1KIIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:47:35 -0500
X-Greylist: delayed 3133 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 03:47:35 EST
Date: Tue, 8 Nov 2011 23:55:10 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Richard Weinberger <richard@nod.at>
Cc: Valdis.Kletnieks@vt.edu, mfasheh@suse.com, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OCFS2 1.6.0 for mainline?
Message-ID: <20111109075508.GA331@noexit.corp.google.com>
Mail-Followup-To: Richard Weinberger <richard@nod.at>,
	Valdis.Kletnieks@vt.edu, mfasheh@suse.com,
	ocfs2-devel@oss.oracle.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4E99A8F3.50206@nod.at>
 <30236.1318700758@turing-police.cc.vt.edu>
 <4E99C7B7.5060405@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99C7B7.5060405@nod.at>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 07:49:43PM +0200, Richard Weinberger wrote:
> Am 15.10.2011 19:45, schrieb Valdis.Kletnieks@vt.edu:
> > On Sat, 15 Oct 2011 17:38:27 +0200, Richard Weinberger said:
> > 
> >> http://oss.oracle.com/projects/ocfs2/source.html states:
> >> "Active development on OCFS2 happens in the mainline kernel."
> >>
> >> But the mainline kernel seems to contain only version 1.5.0.
> >>
> >> Also the linux-next ocfs2 branch has only 1.5.0.
> >> git://oss.oracle.com/git/jlbec/linux-2.6.git linux-next
> >>
> >> Where can I get 1.6.0?
> > 
> > Presumably, it's GPL, so you should be able to get a copy from the
> > person that told you that 1.6.0 exists. ;)
> > 
> > Put differently, why do you think 1.6.0 is available?
> 
> http://oss.oracle.com/projects/ocfs2/
> 
> "OCFS2 1.6 RELEASE
> 
> OCFS2 1.6.3-1 and OCFS2 Tools 1.6.3-1 are the latest versions. The new
> features available in this release include Extended Attributes, POSIX
> ACLs, REFLINKs, Indexed Directories, Allocation Reservation, Metadata
> Checksums and User/Group Quotas."
> 
> Looks like it's only available for "Unbreakable Linux" subscribers.
> The development seems to be detached from mainline. :-(

Hello Folks,
	Sorry I'm late to this game, but it's worth repeating.
	Thankfully, you're just confused by shoddy version numbers.  ALL
ocfs2 development happens in mainline.  Any code that is in the 1.6.0
release, or any RPM release, started in mainline.
	We don't really pay any attention to the version number reported
in the mainline code.  It's said 1.5.0 for years now.  Mainline is
versioned by the kernel release.
	To repeat, ALL of the code in the 1.6.x RPM (or any RPM put out
by Oracle or SuSE) started in mainline, with the possible exception of
any trivial compatability fixes.  If you have the latest Linus code, you
have the latest ocfs2 code.

Joel

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

			http://www.jlbec.org/
			jlbec@evilplan.org
