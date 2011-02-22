Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1BVIEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:04:49 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40049 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1BVIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:04:48 -0500
Date: Tue, 22 Feb 2011 09:04:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
Message-ID: <20110222080446.GA25012@merkur.ravnborg.org>
References: <4D5DB83D.80205@snapgear.com> <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6> <4D6319E0.9080907@snapgear.com> <AANLkTi=QkXK7=DQ5H1PFttTk+iug_npCsz112RYXd7BR@mail.gmail.com> <20110222072951.GA24953@merkur.ravnborg.org> <AANLkTi=o9hQM1DqbBOAsDpxBW9U1uHsUZ6q3Kw48OBb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=o9hQM1DqbBOAsDpxBW9U1uHsUZ6q3Kw48OBb6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:40:53AM +0100, Geert Uytterhoeven wrote:
> On Tue, Feb 22, 2011 at 08:29, Sam Ravnborg <sam@ravnborg.org> wrote:
> >> >> Is there a plan to move m68k to the generic facilities as well ?
> >>
> >> Moving m68k to genirq is (the next thing?) on my list...
> >
> > If I succeed migrating sparc32 to genirq I hope to be of a little help here.
> > It looks like a bigger task to migrate m68k than it was/is to migrate sparc32.
> >
> > It would be _very_ nice to get the last two architectures migrated to genirq.
> 
> Aren't your forgetting s390?
Hmm, I had the understanding that m68k and sparc32 was the only two remaining :-(
But I did not check.

s390 sees more active maintenance so if they become the last non genirq user,
then they may feel a bit of pressure :-)

	Sam
