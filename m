Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DNNxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:53:14 -0400
Received: from ppsw-c.csi.cam.ac.uk ([131.111.8.136]:52853 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195Ab0DNNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:53:13 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC5C96B.7050901@cam.ac.uk>
Date: Wed, 14 Apr 2010 14:55:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jean Delvare <khali@linux-fr.org>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Various intel small device drivers
References: <20100414124913.23181.75903.stgit@localhost.localdomain>	<20100414153052.4e07f0cc@hyperion.delvare> <20100414144912.12c83f51@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414144912.12c83f51@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/10 14:49, Alan Cox wrote:
>>> Kalhan Trisal (4):
>>>       emc1403: thermal sensor support
>>>       liss331d1: accelerometer driver
>>>       isl29020: ambient light sensor
>>>       hmc6352: Add driver for the HMC6352 compass
>>
>> The liss331d1, isl29020 and hmc6352 are not hardware monitoring drivers
> 
> Disagree somewhat. In fact on close grepping I find that there is another
> related lis33 implementation in drivers/hwmon already 8)
> 
> Given all the accelerometers are in drivers/hwmon where do you think they
> should be, and do you have pending patches to move the others ?
> 
> I'd also be interested where you think the compass fits if its not hwmon,
> ditto the ambient light sensor ?

If you like, feel free to (re)start an argument with Linus on the ambient light
sensor front.  Or see that thread for yet another round about discussion of
where these sensors should be. 

http://lkml.org/lkml/2010/3/1/367

Basically if it is primarily an input device for human interaction, see if
Dmitry is willing to take it into input (though note he may quite rightly
take some convincing!)

Otherwise, I'm happy to take more general sensors into IIO, but obviously that
is still in staging and evolving reasonably quickly at the moment (large number
of abi clean up patches half way through cleanup at the mo.)

Otherwise, misc with the intent to sweep them all up when an agreed upon
subsystem is in place.

> 
> I'll bounce the emc1403 onto lm-sensors.
> 
> Thanks
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

