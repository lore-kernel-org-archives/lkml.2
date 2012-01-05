Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2AEIHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:07:30 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:38157
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752952Ab2AEIH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:07:28 -0500
Message-ID: <4F055A30.2010309@compulab.co.il>
Date: Thu, 05 Jan 2012 10:07:12 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Wright <chrisw@sous-sol.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Sanjeev Premi <premi@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, stable@vger.kernel.org
Subject: Re: Several MFD patches for stable
References: <4F031233.7040007@compulab.co.il> <20120103210144.GE17131@kroah.com>
In-Reply-To: <20120103210144.GE17131@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/12 23:01, Greg KH wrote:
> On Tue, Jan 03, 2012 at 04:35:31PM +0200, Igor Grinberg wrote:
>> Hi Greg, Chris,
>>
>> I've found several MFD patches that I think should have been
>> applied also to stable, but they hadn't been applied
>> (probably because nobody cared to send them to stable@vger.kernel.org).
>>
>> The patches are upstream:
>> e178ccb33569da17dc897a08a3865441b813bdfb (mfd: Fix mismatch in twl4030 mutex lock-unlock)
>> 66cc5b8e50af87b0bbd0f179d76d2826f4549c13 (mfd: Copy the device pointer to the twl4030-madc structure)
>> d0e84caeb4cd535923884735906e5730329505b4 (mfd: Check for twl4030-madc NULL pointer)
> 
> Ok, I've applied these 3 to the 3.0-stable tree now.
> 
>> 3d6271f92e98094584fd1e609a9969cd33e61122 (mfd: Turn on the twl4030-madc MADC clock)
> 
> And this one to both 3.0-stable and 3.1-stable.

Sorry for the late response, I've just got back online...
Yes, it seems correct.
Sorry for making you work more then expected...
I will specify the relevant kernel versions next time...

Thanks


-- 
Regards,
Igor.
