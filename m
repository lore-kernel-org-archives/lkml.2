Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab1J1RHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:07:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27698 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1J1RHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:07:42 -0400
MIME-Version: 1.0
Message-ID: <b86860d2-3aac-4edd-b460-bd95cb1103e6@default>
Date: Fri, 28 Oct 2011 10:07:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Johannes Weiner <jweiner@redhat.com>, Pekka Enberg <penberg@kernel.org>
Cc: Cyclonus J <cyclonusj@gmail.com>, Sasha Levin <levinsasha928@gmail.com>,
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
 <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
 <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com
 20111028163053.GC1319@redhat.com>
In-Reply-To: <20111028163053.GC1319@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EAAE144.0095,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Johannes Weiner [mailto:jweiner@redhat.com]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On Fri, Oct 28, 2011 at 06:36:03PM +0300, Pekka Enberg wrote:
> > On Fri, Oct 28, 2011 at 6:21 PM, Dan Magenheimer
> > <dan.magenheimer@oracle.com> wrote:
> > Looking at your patches, there's no trace that anyone outside your own
> > development team even looked at the patches. Why do you feel that it's
> > OK to ask Linus to pull them?
> 
> People did look at it.
> 
> In my case, the handwavy benefits did not convince me.  The handwavy
> 'this is useful' from just more people of the same company does not
> help, either.
> 
> I want to see a usecase that tangibly gains from this, not just more
> marketing material.  Then we can talk about boring infrastructure and
> adding hooks to the VM.
> 
> Convincing the development community of the problem you are trying to
> solve is the undocumented part of the process you fail to follow.

Hi Johannes --

First, there are several companies and several unaffiliated kernel
developers contributing here, building on top of frontswap.  I happen
to be spearheading it, and my company is backing me up.  (It
might be more appropriate to note that much of the resistance comes
from people of your company... but please let's keep our open-source
developer hats on and have a technical discussion rather than one
which pleases our respective corporate overlords.)

Second, have you read http://lwn.net/Articles/454795/ ?
If not, please do.  If yes, please explain what you don't
see as convincing or tangible or documented.  All of this
exists today as working publicly available code... it's
not marketing material.

Dan
