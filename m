Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0E0X0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:26:31 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:22723 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756665Ab0E0X03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:26:29 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 19:26:29 EDT
Date: Fri, 28 May 2010 09:15:38 +1000
From: David McCullough <david_mccullough@mcafee.com>
To: microblaze-uclinux@itee.uq.edu.au
CC: monstr@monstr.eu, linux-m32r@ml.linux-m32r.org, uclinux-dev@uclinux.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [microblaze-uclinux] Re: [Uclinux-dist-devel] [PATCH 1/2 v2]
 FLAT: split the stack & data alignments
Message-ID: <20100527231538.GA1615@mcafee.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
 <1274863506-14168-1-git-send-email-vapier@gentoo.org>
 <4BFE2C3E.5090704@monstr.eu>
 <AANLkTinD5VI-piiv6CWnZMei4ARTLDF61r0O7wvddRDP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinD5VI-piiv6CWnZMei4ARTLDF61r0O7wvddRDP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 May 2010 23:15:40.0884 (UTC) FILETIME=[86325940:01CAFDF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> On Thu, May 27, 2010 at 04:24, Michal Simek wrote:
> > Mike Frysinger wrote:
> >> The stack and data have different alignment requirements, so don't force
> >> them to wear the same shoe. ??Increase the data alignment to match that
> >> which the elf2flt linker script has always been using: 0x20 bytes. ??Not
> >> only does this bring the kernel loader in line with the toolchain, but
> >> it also fixes a swath of gcc tests which try to force larger alignment
> >> values but randomly fail when the FLAT loader fails to deliver.
> >>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >
> > Solve the problem on Microblaze:
> >
> > Tested-by: Michal Simek <monstr@monstr.eu>
> >
> > Who will add it to mainline?
> 
> if we can get the misc nommu peeps to agree on this (looking mostly at
> David [McCullough] and Greg), then akpm will most likely expedite the
> merge.  i like to think they're the best FLAT experts out there ;).

Did the latest patch include the changes Paul requested.

It looks like it to me,  I've just been a bit distracted.  If so I'll send
in an Ack.

Cheers,
Davidm

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
