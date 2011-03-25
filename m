Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1CYOUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:20:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31179 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1CYOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:20:51 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-reply-to: <1301062675-sup-2548@think>
References: <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de> <4D8CA263.9090006@fusionio.com> <20110325141413.GA1725@gentoo.trippels.de> <1301062675-sup-2548@think>
Date: Fri, 25 Mar 2011 10:19:49 -0400
Message-Id: <1301062767-sup-540@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D8CA4BC.019E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Chris Mason's message of 2011-03-25 10:18:19 -0400:
> Excerpts from Markus Trippelsdorf's message of 2011-03-25 10:14:13 -0400:
> > On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
> > > On 2011-03-25 14:09, Markus Trippelsdorf wrote:
> > > > On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
> > > >> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
> > > >>>
> > > >>> Reverting it solves all problems here.
> > > >>
> > > >> Can you try this one?
> > > > 
> > > > This one doesn't help; I still get the same BUG.
> > > > 
> > > > BTW if you're having trouble reproducing this, here is the only non
> > > > stock xfs option that I use on the affected partitions:
> > > > 
> > > > noatime,logbsize=262144
> > > 
> > > This?
> > 
> > No.
> > 
> 
> I was able to reproduce it here.  This is working for me:
> 

Sorry, this is working better but still explodes later.  Don't bother
with this one.

-chris
