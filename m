Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1HPWep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 18:34:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34032 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab1HPWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 18:34:43 -0400
X-Sasl-enc: WsoOrz/YzJJU7u0rgNnQ+1Ha+HMf1cG2GqA8604ESGvd 1313534082
Date: Tue, 16 Aug 2011 15:33:27 -0700
From: Greg KH <greg@kroah.com>
To: "Jeremiah C. Foster" <jeremiah@jeremiahfoster.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Message-ID: <20110816223327.GA1534@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
 <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 09:26:24PM +0200, Jeremiah C. Foster wrote:
> I'd like to echo Ben's sentiment, particularly in the area of automotive. 
> A car has to be supported with parts for at least ten years, often longer, 
> and this includes the build system for the infotainment software.
> The GENIVI Alliance is now building infotainment systems for their member 
> companies (BMW, GM, PSA, Hyundai, etc.) which will have to preserve a 
> working kernel for a long time, like lark's tongues in aspic. So there is an 
> interest in a "longterm, stable" kernel in the automotive industry. Furthermore,
> know-how around choosing a long term kernel relevant to a car is in short 
> supply, so there is a lot of reliance on the distros and commercial OSVs in 
> this regard.

Isn't that the job of the distros and commercial OSVs today?  Are they
somehow not doing this job well?  Do they need help from the community
instead to help define, implement, and maintain this for them?

I'm genuinely curious about this, I haven't heard this directly from
users before, only from companies who are in this line of work, wanting
help in doing this for them, for a variety of odd reasons.

If so, doesn't this imply that maybe those users should be choosing a
different company for this support, or that they have given up on this
and want to work directly with the community instead?  If the latter,
I'd be very happy to work with them, contacts are greatly appreciated.

greg k-h
