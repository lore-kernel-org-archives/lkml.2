Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1ABVkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:40:41 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11478 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1ABVkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:40:39 -0500
Date: Sun, 2 Jan 2011 22:40:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stefani Seibold <stefani@seibold.net>
cc: Daniel Baluta <daniel.baluta@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, shemminger@vyatta.com
Subject: Re: [PATCH] new UDPCP Communication Protocol
In-Reply-To: <1294003993.5675.3.camel@wall-e>
Message-ID: <alpine.LNX.2.00.1101022239010.11481@swampdragon.chaosbits.net>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>  <AANLkTi=7M=gSgBjcrCVEj+GKZ5cf5t4MPqm6r9NGr=MZ@mail.gmail.com> <1294003993.5675.3.camel@wall-e>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Jan 2011, Stefani Seibold wrote:

> Am Sonntag, den 02.01.2011, 21:48 +0200 schrieb Daniel Baluta:
> > Hello,
> > 
> > I have some style comments, please read below.
> > 
> > > +struct udpcp_statistics {
> > > +       unsigned int txMsgs;            /* Num of transmitted messages */
> > > +       unsigned int rxMsgs;            /* Num of received messages */
> > > +       unsigned int txNodes;           /* Num of receiver nodes */
> > > +       unsigned int rxNodes;           /* Num of transmitter nodes */
> > > +       unsigned int txTimeout;         /* Num of unsuccessful transmissions */
> > > +       unsigned int rxTimeout;         /* Num of partial message receptions */
> > > +       unsigned int txRetries;         /* Num of resends */
> > > +       unsigned int rxDiscardedFrags;  /* Num of discarded fragments */
> > > +       unsigned int crcErrors;         /* Num of crc errors detected */
> > 
> > Is there any strong reason to have this camel case naming?
[...]
> > 
> > same here.
> > 
> 
> I think there is no nameing convention in linux, as i know it is a
> developer decision.
> 

Chapter 4 of Documentation/CodingStyle seems to disagree with you:


"                Chapter 4: Naming

C is a Spartan language, and so should your naming be.  Unlike Modula-2
and Pascal programmers, C programmers do not use cute names like
ThisVariableIsATemporaryCounter.  A C programmer would call that
variable "tmp", which is much easier to write, and not the least more
difficult to understand.

HOWEVER, while mixed-case names are frowned upon, descriptive names for
global variables are a must.  To call a global function "foo" is a
shooting offense.
"

This seems (to me at least) to suggest that CammelCase is frawned upon.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

