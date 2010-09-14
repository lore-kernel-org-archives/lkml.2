Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0INNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:09:59 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:42319 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0INNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:09:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C8F7429.1080105@jic23.retrosnub.co.uk>
Date: Tue, 14 Sep 2010 14:10:01 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hemanth V <hemanthv@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
References: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com> <4C877584.7000902@jic23.retrosnub.co.uk> <20100914080003.GD15167@core.coreip.homeip.net>
In-Reply-To: <20100914080003.GD15167@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/10 09:00, Dmitry Torokhov wrote:
> On Wed, Sep 08, 2010 at 12:37:40PM +0100, Jonathan Cameron wrote:
>>
>> I'm happy to see your driver go in as it is currently, what bothers me is that we will end
>> up with incompatible interfaces for all the accelerometers Dmitry takes!
>>
> 
> This is a valid concern. How about I chicken out and will not merge any
> new sysfs knobs until you guys decide on reasonable interface? Most set
> up is done by board code anyways, sysfs is more of nice-to-have?
Hemanth, would removing the sysfs hooks from this driver be ok with you?
I'd personally have favoured a merge, add new interfaces when agreed and
deprecate old ones approach, but it is Dmitry's call.  Perhaps it is better
to get the majority of the device functionality in place now and add
the bells and whistles later.

For input device things are probably mostly fixed for a particular board
design.  There are definitely interesting things one can do if the knobs
are available but they (I think) mostly fall outside of using the device
for input!

Jonathan
