Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab1JGLCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:02:37 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52848 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1JGLCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:02:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8EDE45.5030507@cam.ac.uk>
Date: Fri, 07 Oct 2011 12:11:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Himanshu Chauhan <hschauhan@nulltrace.org>
CC: Greg KH <greg@kroah.com>, Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a device
 number
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org> <20111005193359.GB26664@kroah.com> <20111006041011.GB2125@ubuntu.ubuntu-domain> <20111006182500.GA18607@kroah.com> <20111006190752.GA28455@ericsson.com> <20111007064240.GA2944@ubuntu.ubuntu-domain> <20111007065237.GA27805@kroah.com> <20111007095621.GB2944@ubuntu.ubuntu-domain>
In-Reply-To: <20111007095621.GB2944@ubuntu.ubuntu-domain>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/11 10:56, Himanshu Chauhan wrote:
> On Thu, Oct 06, 2011 at 11:52:37PM -0700, Greg KH wrote:
>> On Fri, Oct 07, 2011 at 12:12:40PM +0530, Himanshu Chauhan wrote:
>>> On Thu, Oct 06, 2011 at 12:07:52PM -0700, Guenter Roeck wrote:
>>>> And why, and what for.
>>>
>>> The initial idea of posting to kernelnewbies was to get a hint on how
>>> the patch would be taken as. I wanted to know if developers will like
>>> the idea behind it or not. I guess, Guenter is not convinced with
>>> any of my reasoning. I am willing to clean it up further only if
>>> I get a positive hint. But it doesn't seem to be going anywhere.
>>>
>>> Thanks Guenter, Alan, and Greg for taking your time and reviewing it.
>>>
>>> Greg: To answer your last question, if this was taken positively, I
>>> was thinking of having functionality similar to misc device registration.
>>
>> But why?  What is that device node going to be used for?  Who would be
>> using it in userspace and where would it be tied into in the kernel?
>>
> The device node, as I said earlier, can be used for doing IOCTLS. In user space,
> applications that manage and monitor system environment will need to use this
> interface for querying the sensor's location, for example. In side the kernel,
> the driver that is driving the particular hardware sensor can register a char
> interface for all this and then register with hwmon with the same major/minor
> for usual sysfs export of data.
If location is useful info why not propose a sysfs interface for it?
