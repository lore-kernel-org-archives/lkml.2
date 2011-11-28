Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1K1OVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab1K1OV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:21:29 -0500
Subject: Proposed removal of DECnet support (was: Re: [BUG] 3.2-rc2: BUG
 kmalloc-8: Redzone overwritten)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        levinsasha928@gmail.com, mpm@selenic.com, cl@linux-foundation.org,
        penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4ED35B3E.7040105@redhat.com>
References: <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321873110.2710.13.camel@menhir>
	 <20111126.155028.1986754382924402334.davem@davemloft.net>
	 <4ED35B3E.7040105@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 28 Nov 2011 14:22:41 +0000
Message-ID: <1322490161.2711.26.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-11-28 at 09:58 +0000, Christine Caulfield wrote:
> On 26/11/11 20:50, David Miller wrote:
> > From: Steven Whitehouse<swhiteho@redhat.com>
> > Date: Mon, 21 Nov 2011 10:58:30 +0000
> >
> >> I have to say that I've been wondering lately whether it has got to the
> >> point where it is no longer useful. Has anybody actually tested it
> >> lately against "real" DEC implementations?
> >
> > I doubt it :-)
> >
> 
> DECnet is in use against real DEC implementations - I have checked it 
> quite recently against a VAX running OpenVMS. How many people are 
> actually using it for real work is a different question though.
> 
Ok, thats useful info.

> It's also true that it's not really supported by anyone as I orphaned it 
> some time ago and nobody else seems to care enough to take it over. So 
> if it's becoming a burden on people doing real kernel work then I don't 
> think many tears will be wept for its removal.
> 
> Chrissie

Really the only issue with keeping it around is the maintenance burden I
think. It doesn't look like anybody wants to take it on, but maybe we
should give it another few days for someone to speak up, just in case
they are on holiday or something at the moment.

Also, I've updated the subject of the thread, to make it more obvious
what is being discussed, as well as bcc'ing it again to the DECnet list,

Steve.


