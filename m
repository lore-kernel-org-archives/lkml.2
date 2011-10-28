Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1J1PWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:22:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57550 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab1J1PWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:22:35 -0400
MIME-Version: 1.0
Message-ID: <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
Date: Fri, 28 Oct 2011 08:21:31 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <75efb251-7a5e-4aca-91e2-f85627090363@default>
 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.com
 CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
In-Reply-To: <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EAAC87F.0008,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> 
> On Fri, Oct 28, 2011 at 10:30 AM, Cyclonus J <cyclonusj@gmail.com> wrote:
> >> I felt it would be difficult to try and merge any tmem KVM patches until
> >> both frontswap and cleancache are in the kernel, thats why the
> >> development is currently paused at the POC level.
> >
> > Same here. I am working a KVM support for Transcedent Memory as well.
> > It would be nice to see this in the mainline.
> 
> We don't really merge code for future projects - especially when it
> touches the core kernel.

Hi Pekka --

If you grep the 3.1 source for CONFIG_FRONTSWAP, you will find
two users already in-kernel waiting for frontswap to be merged.
I think Sasha and Neo (and Brian and Nitin and ...) are simply
indicating that there can be more, but there is a chicken-and-egg
problem that can best be resolved by merging the (really very small
and barely invasive) frontswap patchset.
 
> As for the frontswap patches, there's pretty no ACKs from MM people
> apart from one Reviewed-by from Andrew. I really don't see why the
> pull request is sent directly to Linus...

Has there not been ample opportunity (in 2-1/2 years) for other
MM people to contribute?  I'm certainly not trying to subvert any
useful technical discussion and if there is some documented MM process
I am failing to follow, please point me to it.  But there are
real users and real distros and real products waiting, so if there
are any real issues, let's get them resolved.

Thanks,
Dan

P.S. before commenting further, I suggest that you read the 
background material at http://lwn.net/Articles/454795/
(with an open mind :-).
