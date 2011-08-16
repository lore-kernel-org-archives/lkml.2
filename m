Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1HPTce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:32:34 -0400
Received: from a-pb-sasl-sd.pobox.com ([74.115.168.62]:57432 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1HPTcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:32:33 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 15:32:32 EDT
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e.
 how we pick them).
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: "Jeremiah C. Foster" <jeremiah@jeremiahfoster.com>
In-Reply-To: <1313460542.2981.76.camel@deadeye>
Date: Tue, 16 Aug 2011 21:26:24 +0200
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stable-review@kernel.org, stable@kernel.org,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
To: Ben Hutchings <ben@decadent.org.uk>
X-Mailer: Apple Mail (2.1244.3)
X-Pobox-Relay-ID: A42BF26E-C83D-11E0-8A34-B797DE995924-97416961!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16, 2011, at 4:09, Ben Hutchings wrote:

> On Sun, 2011-08-14 at 21:15 -0700, Greg KH wrote:
> [...]
>> Today:
>> 
>> Now that 2.6.32 is over a year and a half, and the enterprise distros
>> are off doing their thing with their multi-year upgrade cycles, there's
>> no real need from the distros for a new longterm kernel release.  But it
>> turns out that the distros are not the only user of the kernel, other
>> groups and companies have been approaching me over the past year, asking
>> how they could pick the next longterm kernel, or what the process is in
>> determining this.
>> 
>> To keep this all out in the open, let's figure out what to do here.
>> Consumer devices have a 1-2 year lifespan, and want and need the
>> experience of the kernel community maintaining their "base" kernel for
>> them.
> 
> This timespan is both somewhat optimistic with respect to current
> reality, and also rather depressing in that it sets a very low bar.  I
> would hope that we don't collectively treat consumer electronics as
> disposable and that responsible vendors would like to provide security
> support for a lifetime of 5-10 years.  (But no, I don't think that's
> easy.)

I'd like to echo Ben's sentiment, particularly in the area of automotive. 
A car has to be supported with parts for at least ten years, often longer, 
and this includes the build system for the infotainment software.
The GENIVI Alliance is now building infotainment systems for their member 
companies (BMW, GM, PSA, Hyundai, etc.) which will have to preserve a 
working kernel for a long time, like lark's tongues in aspic. So there is an 
interest in a "longterm, stable" kernel in the automotive industry. Furthermore,
know-how around choosing a long term kernel relevant to a car is in short 
supply, so there is a lot of reliance on the distros and commercial OSVs in 
this regard.

Regards,

Jeremiah