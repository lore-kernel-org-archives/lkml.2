Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1HXNDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:03:31 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:44672 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1HXND2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:03:28 -0400
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jeremiah Foster <jeremiah@jeremiahfoster.com>
In-Reply-To: <20110824044636.GC786@kroah.com>
Date: Wed, 24 Aug 2011 15:03:22 +0200
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <41C541C8-0AB3-438B-86D6-D535576D7633@jeremiahfoster.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
 <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
 <20110816223327.GA1534@kroah.com>
 <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
 <20110824044636.GC786@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
X-Pobox-Relay-ID: 73A1C08C-CE51-11E0-B630-1DC62E706CDE-97416961!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24, 2011, at 06:46, Greg KH wrote:

> On Wed, Aug 17, 2011 at 12:33:56PM +0200, Jeremiah Foster wrote:
>> 
>> On Aug 17, 2011, at 00:33, Greg KH wrote:
>>> On Tue, Aug 16, 2011 at 09:26:24PM +0200, Jeremiah C. Foster wrote:

[snip]

>>> Are they
>>> somehow not doing this job well?  
>> 
>> I think they are doing the job well which is why there is increasing
>> choice; use a distro or pay for an OSV? Rely on the community or
>> develop in-house competence? These questions are new, at least for the
>> automotive industry, since previously it was all proprietary all the
>> time.
> 
> Yes, it's a new model that they need to get used to :)

I think this is what they have realized. I think they are actually trying to use that model but that has changed things for them. When I said they maintain build systems and software for ten years I was speaking of the current model. When I went back and spoke to the software developers who work for car makers they said that things are changing. The pace of development in consumer electronics has affected what you have to put in a car. People expect a certain level of software functionality in a high end car so the car makers have had to adapt. 

The ten year model may be coming to an end. Over the air updates, once a year dealer updates, and mileage-based service updates are all now opportunities to ship bug fixes and potentially new features. So it looks like a 5 year model, or even shorter, might be usable.

Currently there are agreements between car makers and their software partners and as these groups both get more familiar with open source hopefully they'll be better prepared to work with the mainline kernel maintainers and to be open about their requirements. Right now unfortunately they are not able to do that.

[snip]

>>> I'm genuinely curious about this, I haven't heard this directly from
>>> users before, only from companies who are in this line of work, wanting
>>> help in doing this for them, for a variety of odd reasons.
>> 
>> If it helps at all, I can bring up this topic inside GENIVI and ask if
>> there are OEMs, Tier 1s and others who would be interested in how to
>> identify a kernel that is appropriate for their long-term needs. I
>> have participated in GENIVI discussions like this previously and there
>> has not necessarily been clarity. Having your perspective and the
>> perspective of others with experience in kernel maintenance would be
>> helpful.
> 
> Please do.  My view of GENIVI from the outside is that it reminds me a
> lot of the problems that plagued the old CGL initiative.  Hopefully that
> is incorrect on my part.

There are certain overlaps between the two projects that's for sure.

> If there's anyone, or any group, I should be talking to about this, or
> any meeting I could attend to help explain it all better, please let me
> know, I am more than willing to do so.

I proposed that the GENIVI system architects meet with you to discuss this, but currently there is no clear picture inside the OEMs about identifying even a particular kernel version let alone how long it needs to be maintained, so it was deemed that a meeting now would not be very productive. I've encouraged individual companies to get in touch with you on one of the kernel lists or drop you an email.

Individual GENIVI members attend the regular Linux conferences and there may be an automotive BoF in Prague if you're there.

>>> If so, doesn't this imply that maybe those users should be choosing a
>>> different company for this support, or that they have given up on this
>>> and want to work directly with the community instead?  
>> 
>> That is the eternal question. For the auto industry it often boils
>> down to the cost / benefit ratio and the cost sensitivity for
>> production vehicles per unit is a major factor in what they choose. I
>> think if they can find a reasonable long-term kernel they'll help
>> maintain it in conjunction with the community.
> 
> That's good to hear, any help is appreciated.
> 
> Mostly I want to know what patches should be applied, that fix problems
> they have.  That and testing the -rc releases would be wonderful.

I'll make sure to communicate this since the GENIVI releases are really more of a developer's baseline than they are polished production images. So it seems like the opportunity to test -rc releases is there.

>>> If the latter,
>>> I'd be very happy to work with them, contacts are greatly appreciated.
>> 
>> Very generous of you. Let me see if I can pull together a list of
>> people where this can be discussed.
> 
> That would be great, odds are, a new thread can be started, and everyone
> on cc: taken off, as I doubt they care about this :)

I'm following up with everyone on cc just so that they can see the outcome of this thread, which sadly I think is anti-climactic. I hope to drag GENIVI members onto the public kernel lists when they have questions.

Regards,

Jeremiah