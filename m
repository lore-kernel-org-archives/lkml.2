Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1JXJOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:14:38 -0400
Received: from plane.gmane.org ([80.91.229.3]:45162 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1JXJOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:14:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EA52C78.3030105@cam.ac.uk>
Date: Mon, 24 Oct 2011 10:14:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Maxin B John 
	<public-maxin.john-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Jonathan Cameron 
	<public-jic23-KWPb1pKIrIJaa/9Udqfwiw@plane.gmane.org>,
        Dan Carpenter 
	<public-error27-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Bryan Freed 
	<public-bfreed-F7+t8E8rja9g9hUCZPvPmw@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Greg Kroah-Hartman <public-gregkh-l3A5Bk7waGM@plane.gmane.org>,
        public-linux-iio-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Arnd Bergmann <public-arnd-r2nGTMty4D4@plane.gmane.org>,
        public-devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@plane.gmane.org,
        Amit Kucheria 
	<public-amit.kucheria-LY4KaoCqKrnby3iVrkZq2A@plane.gmane.org>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
References: <20110902094107.GA2846@maxin> <4E60B63C.1030101@cam.ac.uk> <CAMhs6Yzw3-CARTULhy4s-Re4Q82Ek9gZGUQtABLLs0PSArHCuw@mail.gmail.com> <4EA52710.2060108@cam.ac.uk> <20111024090143.GB3526@mwanda>
In-Reply-To: <20111024090143.GB3526@mwanda>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/11 10:01, Dan Carpenter wrote:
> On Mon, Oct 24, 2011 at 09:51:28AM +0100, Jonathan Cameron wrote:
>>>>> Signed-off-by: Maxin B. John <maxin.john-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> Acked-by: Jonathan Cameron <jic23-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
>>>>
>>>
>>> Sorry for the delay in replying to this mail. I am curious about the
>>> status of this patch. I couldn't locate this patch at  iio-blue.git as
>>> it is not present in kernel.org now
>>> (http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary)
>>> Please ignore this mail if you have already added this patch to your tree.
>> Ah, sorry I slipped up here and should have noticed it didn't go directly to
>> Greg. Just to check, with everyone I have author as Dan, reporter as Maxin
>> and have signed off myself (it's going through my tree anyway now).
>>
>> I think from looking back it was Dan's suggestion in response to Maxin's
>> patch.  Hence convention would be a sign off from Dan and perhaps an
>> Ack from Maxin?
>>
> 
> Maxim is the author.  He didn't resend this in the proper way so it
> was confusing...  Can you give me a Reviewed-by tag?
> 
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Sure.


