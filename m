Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0KEANN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:13:13 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:61037 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966Ab0KEANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:13:11 -0400
Message-ID: <4CD34C4D.5070609@bluewatersys.com>
Date: Fri, 05 Nov 2010 13:14:05 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Charles Manning <manningc2@actrix.gen.nz>, cdhmanning@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <20101103174607.GA6777@kroah.com> <201011050958.39020.manningc2@actrix.gen.nz> <20101104223641.GA3596@kroah.com>
In-Reply-To: <20101104223641.GA3596@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 11:36 AM, Greg KH wrote:
> On Fri, Nov 05, 2010 at 09:58:38AM +1300, Charles Manning wrote:
>> On Thursday 04 November 2010 06:46:07 Greg KH wrote:
>>> On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
>>>> From: Charles Manning <cdhmanning@gmail.com>
>>>>
>>>> Adding yaffs2 file system.
>>>>
>>>> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
>>>> ---

>>> Also, is your goal to get this cleaned up good enough to get it into .38
>>> in the "real" place in the kernel, or do you want to see it go through
>>> staging and take a bit longer to get everything cleaned up properly
>>> before moving to the "real" location?
>>
>> My goal it to get this into mainline, .38 preferred.
>>
>> I am a complete newbie when it comes to this process. What's the best
>> path to getting there? 
> 
> I don't know, both will work.
> 
>> My preference is to keep cleaning up code in yaffs.net and patching
>> from there as this will keep the trees closer together and minimise
>> clerical issues.
> 
> Sure, but remember, once the code goes into mainline, having an external
> tree is a huge liability, not a benifit at all, so consider dropping it.

The Yaffs codebase also runs on other operating systems. Charles has
cleaned the code up to match the Linux coding style and removed the
support for other operating systems in the patches which he is
attempting to push to mainline.

I believe his intention is to maintain his own, portable, yaffs codebase
which supports Linux and other systems out of tree. There will be some
work for Charles in keeping these two codebases in sync, but that won't
have any visible effect to Linux.

The trick for Charles is to make the Yaffs code which he is submitting
for mainline inclusion clean according to the Linux coding standards,
without creating a maintainence nightmare for himself :-).

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
