Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3AGP7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:59:32 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:33139 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab3AGP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:59:30 -0500
X-ASG-Debug-ID: 1357574369-03d6a567bb4f440001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Mon, 7 Jan 2013 10:59:25 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Ric Wheeler <rwheeler@redhat.com>
CC: Keith Chew <keith.chew@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: data=guarded mode in ext3
Message-ID: <20130107155925.GC30947@shiny>
X-ASG-Orig-Subj: Re: data=guarded mode in ext3
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Ric Wheeler <rwheeler@redhat.com>, Keith Chew <keith.chew@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chris Mason <clmason@fusionio.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <CAKaWdxYi_RpjSAp9sL9oeM2i1sCR5foKpvV2bCHDrbM0Dj3DtA@mail.gmail.com>
 <50EAEDF0.4010609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50EAEDF0.4010609@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1357574369
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.119191
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 08:46:56AM -0700, Ric Wheeler wrote:
> On 12/03/2012 09:34 PM, Keith Chew wrote:
> > Hi
> >
> > Just wanted to check if the "'Data=guarded' mode in Ext3" work started
> > by Chris Mason, is still being considered for merging to the mainline
> > kernel? Or has that effort stopped?
> >
> > Regards
> > Keith
> >
> 
> Hi Keith,
> 
> I think that Chris is spending pretty much all of his time on btrfs these days. 
> I believe this work is pretty much abandoned at this point...
> 
> What are you looking for specifically from this?

Ric has it right, the change was big enough that I didn't think it was
worth the risk of changing how ext3 works.  Most people are going to
want ext4 anyway for a lot of reasons, so it made sense to focus bigger
changes in the ext4 code base.

-chris
