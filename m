Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1HXEsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:48:19 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44636 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1HXEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:48:17 -0400
X-Sasl-enc: FHaZO22W4303KIOTA6nXtwiYN8VfebSHCL/KIt6GLnrt 1314161296
Date: Tue, 23 Aug 2011 21:46:36 -0700
From: Greg KH <greg@kroah.com>
To: Jeremiah Foster <jeremiah@jeremiahfoster.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Message-ID: <20110824044636.GC786@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
 <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
 <20110816223327.GA1534@kroah.com>
 <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 12:33:56PM +0200, Jeremiah Foster wrote:
> 
> On Aug 17, 2011, at 00:33, Greg KH wrote:
> > On Tue, Aug 16, 2011 at 09:26:24PM +0200, Jeremiah C. Foster wrote:
> >> I'd like to echo Ben's sentiment, particularly in the area of automotive. 
> >> A car has to be supported with parts for at least ten years, often longer, 
> >> and this includes the build system for the infotainment software.
> >> The GENIVI Alliance is now building infotainment systems for their member 
> >> companies (BMW, GM, PSA, Hyundai, etc.) which will have to preserve a 
> >> working kernel for a long time, like lark's tongues in aspic. So there is an 
> >> interest in a "longterm, stable" kernel in the automotive industry. Furthermore,
> >> know-how around choosing a long term kernel relevant to a car is in short 
> >> supply, so there is a lot of reliance on the distros and commercial OSVs in 
> >> this regard.
> > 
> > Isn't that the job of the distros and commercial OSVs today?  
> 
> My understanding is yes. It appears to be a business opportunity for
> many OSVs and others as well, but the distro's are doing a good job so
> increasingly commercial companies are turning to distros, at least
> initially.
> 
> > Are they
> > somehow not doing this job well?  
> 
> I think they are doing the job well which is why there is increasing
> choice; use a distro or pay for an OSV? Rely on the community or
> develop in-house competence? These questions are new, at least for the
> automotive industry, since previously it was all proprietary all the
> time.

Yes, it's a new model that they need to get used to :)

> > Do they need help from the community
> > instead to help define, implement, and maintain this for them?
> 
> I think the answer is yes.
> 
> > I'm genuinely curious about this, I haven't heard this directly from
> > users before, only from companies who are in this line of work, wanting
> > help in doing this for them, for a variety of odd reasons.
> 
> If it helps at all, I can bring up this topic inside GENIVI and ask if
> there are OEMs, Tier 1s and others who would be interested in how to
> identify a kernel that is appropriate for their long-term needs. I
> have participated in GENIVI discussions like this previously and there
> has not necessarily been clarity. Having your perspective and the
> perspective of others with experience in kernel maintenance would be
> helpful.

Please do.  My view of GENIVI from the outside is that it reminds me a
lot of the problems that plagued the old CGL initiative.  Hopefully that
is incorrect on my part.

If there's anyone, or any group, I should be talking to about this, or
any meeting I could attend to help explain it all better, please let me
know, I am more than willing to do so.

> > If so, doesn't this imply that maybe those users should be choosing a
> > different company for this support, or that they have given up on this
> > and want to work directly with the community instead?  
> 
> That is the eternal question. For the auto industry it often boils
> down to the cost / benefit ratio and the cost sensitivity for
> production vehicles per unit is a major factor in what they choose. I
> think if they can find a reasonable long-term kernel they'll help
> maintain it in conjunction with the community.

That's good to hear, any help is appreciated.

Mostly I want to know what patches should be applied, that fix problems
they have.  That and testing the -rc releases would be wonderful.

> > If the latter,
> > I'd be very happy to work with them, contacts are greatly appreciated.
> 
> Very generous of you. Let me see if I can pull together a list of
> people where this can be discussed.

That would be great, odds are, a new thread can be started, and everyone
on cc: taken off, as I doubt they care about this :)

thanks,

greg k-h
