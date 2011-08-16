Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1HPIsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 04:48:55 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:32823 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HPIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 04:48:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E4A30DC.4080806@cam.ac.uk>
Date: Tue, 16 Aug 2011 09:57:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Jonathan Kunkee <jonathan.kunkee@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [RFC] Moving magnetometer HMC6352 into IIO subsystem
References: <CAGRJchidA8ZTMcJnmfJpoBjjpG1zYFC4XQT8KKxjQUm4o3CCng@mail.gmail.com> <20110815220728.62f27e35@lxorguk.ukuu.org.uk> <CAGRJchgbqqG5xOLoR4EOXBz7YcxmBc0TNsRaH138Qs5k6-e8YA@mail.gmail.com>
In-Reply-To: <CAGRJchgbqqG5xOLoR4EOXBz7YcxmBc0TNsRaH138Qs5k6-e8YA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/11 00:22, Jonathan Kunkee wrote:
>>> Should the HMC6352 digital compass driver be moved [...]?
>>
>> No - that would be a regression .. but read on
> 
>>> [...] they should almost always land in IIO land.
>>
>> IIO is a staging project that may never go anywhere - some of us are
>> using magnetometers in product so this alone isn't an answer that works
>> right now.
> 
> In my reading I failed to catch the how transient 'staging' is--I'll
> keep it mind, as I'm hoping my driver will not be so transient.
> 
>>> I would be willing to work on the change as I want to submit a similar
>>> driver for the HMC6343 magnetometer/accelerometer as well.
>>
>> It would be great if it got added into the IIO subystem *as well*, and in
>> time when and if IIO goes out of staging it would then eventually replace
>> the existing drivers.
> 
> This would then necessitate maintaining both chunks of code, so I think
> for now I will develop my module in drivers/misc. After it has stabilized,
> I can add both modules to IIO as well with this in mind.
> 
Certainly a valid option right now.   Moving things over tends to be
straight forward anyway.

IIO is hoping to make first steps out of staging shortly, but it will be a
good while before anywhere near everything moves out into the main tree
(lots of code and some of it is probably going to be controversial!)

Jonathan
