Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1CYOYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:24:54 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39442 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1CYOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:24:53 -0400
Date: Fri, 25 Mar 2011 15:24:50 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110325142450.GA1737@gentoo.trippels.de>
References: <4D8C4304.3050101@fusionio.com>
 <20110325083757.GA1754@gentoo.trippels.de>
 <4D8C55D9.1060903@fusionio.com>
 <20110325095704.GA1694@gentoo.trippels.de>
 <4D8C8E1C.1020304@fusionio.com>
 <20110325130959.GA1698@gentoo.trippels.de>
 <4D8CA263.9090006@fusionio.com>
 <20110325141413.GA1725@gentoo.trippels.de>
 <1301062675-sup-2548@think>
 <1301062767-sup-540@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301062767-sup-540@think>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.25 at 10:19 -0400, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-03-25 10:18:19 -0400:
> > Excerpts from Markus Trippelsdorf's message of 2011-03-25 10:14:13 -0400:
> > > On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
> > > > On 2011-03-25 14:09, Markus Trippelsdorf wrote:
> > > > > On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
> > > > >> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
> > > > >>>
> > > > >>> Reverting it solves all problems here.
> > > > >>
> > > > >> Can you try this one?
> > > > > 
> > > > > This one doesn't help; I still get the same BUG.
> > > > > 
> > > > > BTW if you're having trouble reproducing this, here is the only non
> > > > > stock xfs option that I use on the affected partitions:
> > > > > 
> > > > > noatime,logbsize=262144
> > > > 
> > > > This?
> > > 
> > > No.
> > > 
> > 
> > I was able to reproduce it here.  This is working for me:
> > 
> 
> Sorry, this is working better but still explodes later.  Don't bother
> with this one.

Yeah, doesn't help here also.
-- 
Markus
