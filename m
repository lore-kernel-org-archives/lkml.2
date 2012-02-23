Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab2BWX7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:59:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58227 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab2BWX7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:59:21 -0500
Message-ID: <4F46D2CD.9030302@zytor.com>
Date: Thu, 23 Feb 2012 15:59:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com> <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <4F46C63C.4040602@zytor.com> <20120223231605.GA15329@kroah.com> <4F46C92B.4090508@zytor.com> <20120223235450.GA22345@kroah.com>
In-Reply-To: <20120223235450.GA22345@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 03:54 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2012 at 03:18:03PM -0800, H. Peter Anvin wrote:
>> On 02/23/2012 03:16 PM, Greg Kroah-Hartman wrote:
>>>
>>> And a "clean" 3.2.7 doesn't have that problem?
>>>
>>> Does the same thing happen in Linus's tree at the moment?
>>>
>>
>> Clean 3.2.7 I don't think has that problem, although of course when I
>> run the stress test it fails on other ways so it's hard to 100% rule out.
>>
>> Linus' tree doesn't have that problems.
> 
> Ugh.
> 
> So, we need more testers, so let me release a -rc kernel with just these
> changes in it, to get a wider testing range, and make an easy "this
> kernel worked, but this one didn't" for people to work with.
> 
> I don't suppose that 'git bisect' would work for this, as it's really a
> "all or nothing" type thing with this series from what I can tell,
> right?
> 

Yes.  At Suresh' suggestion I am running a reference run without AES-NI,
just to make sure we're not chasing a wireless driver bug.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

