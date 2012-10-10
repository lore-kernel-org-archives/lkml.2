Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2JJAEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:04:38 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:20987
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab2JJAEg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:04:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1155h)
Date: Tue, 9 Oct 2012 19:04:26 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: dtc: import latest upstream dtc
To: Mitch Bradley <wmb@firmworks.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <5074B155.4090703@firmworks.com> (from wmb@firmworks.com on Tue
	Oct  9 18:20:53 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1349827466.26044.16@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 06:20:53 PM, Mitch Bradley wrote:
> On 10/9/2012 11:16 AM, Stephen Warren wrote:
> > On 10/01/2012 12:39 PM, Jon Loeliger wrote:
> >>>
> >>> What more do you think needs discussion re: dtc+cpp?
> >>
> >> How not to abuse the ever-loving shit out of it? :-)
> >
> > Perhaps we can just handle this through the regular patch review
> > process; I think it may be difficult to define and agree upon  
> exactly
> > what "abuse" means ahead of time, but it's probably going to be easy
> > enough to recognize it when one sees it?
> 
> 
> One of the ways it could get out of hand would be via "include
> dependency hell".  People will be tempted to reuse existing .h files
> containing pin definitions, which, if history is a guide, will end up
> depending on all sorts of other .h files.
> 
> Another problem I often face with symbolic names is the difficulty of
> figuring out what the numerical values really are (for debugging),
> especially when .h files are in different subtrees from the files that
> use the definitions, and when they use multiple macro levels and fancy
> features like concatenation.  Sometimes I think it's clearer just to
> write the number and use a comment to say what it is.

Both comments apply just as well to ordinary C code, and I don't think  
anyone would seriously suggest just using comments instead for C code.

Is there a way to ask CPP to evaluate a macro in the context of the  
input file, rather than produce normal output?  If not, I guess you  
could make a tool that creates a wrapper file that includes the main  
file and then evaluates the symbol you want.

-Scott
