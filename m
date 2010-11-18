Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab0KRQVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:21:12 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:57317 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0KRQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:21:11 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CE553F7.1050906@cam.ac.uk>
Date: Thu, 18 Nov 2010 16:27:35 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Carmine IASCONE <carmine.iascone@st.com>
CC: Greg KH <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        Matteo DAMENO <matteo.dameno@st.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mems applications <mems.applications@st.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver
References: <1289323527-5501-1-git-send-email-carmine.iascone@st.com> <20101109173540.GA20370@suse.de> <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB115@SAFEX1MAIL3.st.com> <4CDAB795.5080607@gmail.com> <20101110160412.GB10561@suse.de> <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB247@SAFEX1MAIL3.st.com>
In-Reply-To: <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB247@SAFEX1MAIL3.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/10 17:12, Carmine IASCONE wrote:
> Thanks you both for the feedback.
> 
> Best regards,
> Carmine
> 
> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de] 
> Sent: Wednesday, November 10, 2010 5:04 PM
> To: Carmine IASCONE
> Cc: Jiri Slaby; Matteo DAMENO; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; mems applications; Alan Cox
> Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver
> 
> On Wed, Nov 10, 2010 at 04:17:41PM +0100, Jiri Slaby wrote:
>> On 11/10/2010 12:51 PM, Carmine IASCONE wrote:
>>> Hi Greg, Hi JS,
>>> Matteo and I have started to develop linux device drivers for our STMicroelectronics sensors about one year ago. Our main target is the Android platform (mobile phone or tablet pc), and for this reason the drivers are thought to be used on I2C bus. The drivers are enough stable, we have several customers that are using them, and also with the advice of these customers, we would like to make available them for all the linux community, merging them in the kernel upstream to be used in all linux supported platforms.
>>> The drivers have had a initial review by Alan Cox, that gives us some very precious advices to improve the style and robustness of the drivers. 
>>> We are newbies in patch generation and submission: we have followed the instructions in the Greg's video on you tube to create this first patch, so sorry if there is something that we missed. We thought to put the driver in staging directory, because before merging them in the main tree we would like to have a general revision, and also because in this first release we haven't managed the device interrupts yet. At the end the right position for these drivers could be drivers/input/misc.
>>> How do we proceed now? Do we need to generate a new patch adding the TODO file? Please advice.
>>
>> Hi, well, I don't think this should go into staging at all as I think
>> it's clean enough to go upstream directly (but I repeat I'm no IIC
>> expert). So please resend to IIC people:
>> I2C SUBSYSTEM
>> M:      "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
>> M:      "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
>> L:      linux-i2c@vger.kernel.org
>>
>> but before that, move that out of staging to drivers/i2c/ (or anywhere
>> where it make sense).
>>
>> It's perfectly OK to add functionality later (IRQs).
> 
> I agree, this should be sent to Jean and the i2c developers first.
> Please work to get your driver into the main tree, only use staging as a
> last-resort if you have a lot of work left to do on the code.
I haven't done a proper datasheet trawl, but this looks like it is probably
already supported by the lis3lv02 driver (currently still in hwmon I think?)
This driver will move fairly soon (or may already have done so).

lis331dl is listed in the header as supported and naming if nothing else suggests
to me that this part will be similar. If this driver has additional functionality
I would suggest adding it to that driver rather than starting again.

Eric and Guenter added cc'd
