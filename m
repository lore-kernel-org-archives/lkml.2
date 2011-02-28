Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1B1MRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:17:38 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:56607 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1B1MRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:17:36 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D6B9281.4060700@cam.ac.uk>
Date: Mon, 28 Feb 2011 12:18:09 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.embedded
CC: Sascha Hauer <s.hauer@pengutronix.de>, Bill Gatliff <bgat@billgatliff.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-embedded@vger.kernel.org
Subject: Re: [GIT PULL] Generic PWM Device API
References: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com> <20110228103124.GI29521@pengutronix.de> <4D6B86EE.1050908@cam.ac.uk>
In-Reply-To: <4D6B86EE.1050908@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/11 11:28, Jonathan Cameron wrote:
> On 02/28/11 10:31, Sascha Hauer wrote:
>> On Sun, Feb 27, 2011 at 09:38:38PM -0600, Bill Gatliff wrote:
>>> Andrew, Linus:
>>>
>>>
>>> The git repository described in the following pull request implements
>>> a generic PWM device driver API.  This API is intended to eventually
>>> supercede the existing PWM device drivers, but during a migration
>>> period will coexist peacefully with them.
>>
>> Sorry for the late answer, but it took some time to read the patches
>> again.
>>
>> Is it a good idea to have to APIs for the same thing in the kernel?
>> The old API has users whereas the new API has none. How can we migrate
>> from one API to the other when for example the backlight pwm driver
>> depends on the old API, SoC level drivers implement the old API, but
>> the atmel pwm driver is only available for the new API?
>>
> See the info in Bill's previous postings.  He has other drivers queued
> up but wants to break up the review burden by merging this core stuff
> first...
> 
Come to think of it, Bill, could you post these at this stage to
show the full benefit of this move?


