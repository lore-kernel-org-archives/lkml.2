Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1HQKeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:34:06 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:35092 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab1HQKeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:34:01 -0400
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jeremiah Foster <jeremiah@jeremiahfoster.com>
In-Reply-To: <20110816223327.GA1534@kroah.com>
Date: Wed, 17 Aug 2011 12:33:56 +0200
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
 <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
 <20110816223327.GA1534@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
X-Pobox-Relay-ID: 6A9E900E-C8BC-11E0-8295-1DC62E706CDE-97416961!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17, 2011, at 00:33, Greg KH wrote:
> On Tue, Aug 16, 2011 at 09:26:24PM +0200, Jeremiah C. Foster wrote:
>> I'd like to echo Ben's sentiment, particularly in the area of automotive. 
>> A car has to be supported with parts for at least ten years, often longer, 
>> and this includes the build system for the infotainment software.
>> The GENIVI Alliance is now building infotainment systems for their member 
>> companies (BMW, GM, PSA, Hyundai, etc.) which will have to preserve a 
>> working kernel for a long time, like lark's tongues in aspic. So there is an 
>> interest in a "longterm, stable" kernel in the automotive industry. Furthermore,
>> know-how around choosing a long term kernel relevant to a car is in short 
>> supply, so there is a lot of reliance on the distros and commercial OSVs in 
>> this regard.
> 
> Isn't that the job of the distros and commercial OSVs today?  

My understanding is yes. It appears to be a business opportunity for many OSVs and others as well, but the distro's are doing a good job so increasingly commercial companies are turning to distros, at least initially.

> Are they
> somehow not doing this job well?  

I think they are doing the job well which is why there is increasing choice; use a distro or pay for an OSV? Rely on the community or develop in-house competence? These questions are new, at least for the automotive industry, since previously it was all proprietary all the time.

> Do they need help from the community
> instead to help define, implement, and maintain this for them?

I think the answer is yes.

> I'm genuinely curious about this, I haven't heard this directly from
> users before, only from companies who are in this line of work, wanting
> help in doing this for them, for a variety of odd reasons.

If it helps at all, I can bring up this topic inside GENIVI and ask if there are OEMs, Tier 1s and others who would be interested in how to identify a kernel that is appropriate for their long-term needs. I have participated in GENIVI discussions like this previously and there has not necessarily been clarity. Having your perspective and the perspective of others with experience in kernel maintenance would be helpful.

> If so, doesn't this imply that maybe those users should be choosing a
> different company for this support, or that they have given up on this
> and want to work directly with the community instead?  

That is the eternal question. For the auto industry it often boils down to the cost / benefit ratio and the cost sensitivity for production vehicles per unit is a major factor in what they choose. I think if they can find a reasonable long-term kernel they'll help maintain it in conjunction with the community.

> If the latter,
> I'd be very happy to work with them, contacts are greatly appreciated.

Very generous of you. Let me see if I can pull together a list of people where this can be discussed.

@everyone: Should I trim the CC list and limit this to a mailing list? Or would people prefer to remain on CC?

Regards,

Jeremiah