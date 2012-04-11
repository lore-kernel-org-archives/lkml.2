Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678Ab2DKQbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:31:07 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57338 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638Ab2DKQbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:31:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <4F848C7C.5040703@cam.ac.uk> <20120410223722.GY7499@opensource.wolfsonmicro.com> <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com> <20120411153811.GA28101@kroah.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120411153811.GA28101@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Wed, 11 Apr 2012 17:30:47 +0100
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Message-ID: <43cfe506-e7ca-44f6-8225-1476e7a88003@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

>On Wed, Apr 11, 2012 at 07:19:01AM +0100, Jonathan Cameron wrote:
>> 
>> 
>> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> 
>> >On Tue, Apr 10, 2012 at 08:39:40PM +0100, Jonathan Cameron wrote:
>> >
>> >> 1)  Review of code.  This is crucial. If people have a little time
>> >> ripping holes in the core IIO code is what we need.  Arnd did a
>good
>> >job
>> >> of this a while back. Others have done bits of it since.
>> >
>> >> 2) Getting the push code tidied up and pushed out.  I'll post it
>as
>> >an
>> >> updated rfc to linux-iio shortly.  All I had left that definitely
>> >> wanted doing here was cleaning up the example iio to input bridge
>> >> driver.  That can happen later.
>> >
>> >For these two can we refactor in place?  That's pretty much what
>seems
>> >to have been happening anyway...
>> >
>> I guess it comes down to whether Linus will pull.  2 should be there
>> within a week or so anyway depending mostly on analog testing I
>> haven't broken any of their drivers.
>
>Hm, shouldn't I be the one that moves this out of staging?  :)

Sorry. Still in mind set of last try where we a parrallel version planned..

>Anyway, all I care about to get this code out of staging is that you
>feel your userspace api is "sane" and not going to change.  Your
>in-kernel stuff can radically change every kernel release with no
>objection from me at all.
>
>And from what I can tell, your userspace stuff looks pretty stable now,
>right?  So, I don't mind moving this all out of staging for 3.5 as-is.

There are corners of the userspace abi that aren't but they aren't related to the core so we can break the abi docs in two and just move the good stuff... 


>
>If so, I'll be glad to make the change to my repo so it starts to show
>up in linux-next in the "correct" place whenever you want me to.

Will clear current queue under review then that would be great.

Note we will need to leave a lot of drivers in staging for now so move may require a few sed scripts to link up headers etc...  quite a lot of drivers are way off.

Lets start a fresh thread on the move to make sure everyone agrees on what is ready!  

Thanks as ever for all your hard work!

>thanks,
>
>greg k-h

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
