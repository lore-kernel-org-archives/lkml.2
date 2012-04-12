Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432Ab2DLG0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:26:20 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:39593 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab2DLG0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:26:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <4F848C7C.5040703@cam.ac.uk> <20120410223722.GY7499@opensource.wolfsonmicro.com> <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com> <20120411153811.GA28101@kroah.com> <43cfe506-e7ca-44f6-8225-1476e7a88003@email.android.com> <20120411234632.GA11113@kroah.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120411234632.GA11113@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Thu, 12 Apr 2012 07:25:57 +0100
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Message-ID: <2607388f-9d57-4f55-9d7e-9788432ad551@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

>On Wed, Apr 11, 2012 at 05:30:47PM +0100, Jonathan Cameron wrote:
>> >Anyway, all I care about to get this code out of staging is that you
>> >feel your userspace api is "sane" and not going to change.  Your
>> >in-kernel stuff can radically change every kernel release with no
>> >objection from me at all.
>> >
>> >And from what I can tell, your userspace stuff looks pretty stable
>now,
>> >right?  So, I don't mind moving this all out of staging for 3.5
>as-is.
>> 
>> There are corners of the userspace abi that aren't but they aren't
>> related to the core so we can break the abi docs in two and just move
>> the good stuff...
>
>Ok, that sounds like a good first step.
>
>> >If so, I'll be glad to make the change to my repo so it starts to
>show
>> >up in linux-next in the "correct" place whenever you want me to.
>> 
>> Will clear current queue under review then that would be great.
>> 
>> Note we will need to leave a lot of drivers in staging for now so
>move
>> may require a few sed scripts to link up headers etc...  quite a lot
>> of drivers are way off.
>
>Why would some drivers stay?  It should only be because of the
>userspace
>api, not because they don't work properly, that's never stopped drivers
>from entering the main part of the kernel before :)
>
You got it in one.  They have userspace interfaces that are miles from where they should be... 
>> Lets start a fresh thread on the move to make sure everyone agrees on
>> what is ready!
>
>Sounds good.
>
>greg k-h

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
