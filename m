Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1CWTKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:10:20 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:60833 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1CWTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:10:19 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D8A45E5.5@cam.ac.uk>
Date: Wed, 23 Mar 2011 19:11:33 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of existing
 in kernel equivalents.
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-2-git-send-email-jic23@cam.ac.uk> <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com> <20110323160120.GA8770@kroah.com> <4D8A1CB7.4090505@cam.ac.uk> <20110323162351.GB9367@kroah.com> <4D8A21D4.6070102@cam.ac.uk> <20110323184421.GA21728@kroah.com>
In-Reply-To: <20110323184421.GA21728@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 18:44, Greg KH wrote:
> On Wed, Mar 23, 2011 at 04:37:40PM +0000, Jonathan Cameron wrote:
>>> Ok, perhaps the name might need to be changed a bit, but the idea is
>>> still good to have.  Please try again.
>>>
>> Any thoughts on what naming would work?  Nothing immediately comes to mind
>> which is why I ended up pinching the kstrto* naming...
>>
>> reallysloppy_strtobool?
>> guessintent_strtobool?
> 
> usr_strtobool?  I don't care :)
That works for me.  Anything usr related is clearly sloppy ;)
> 
>> or the old classic underscore prefix to 'encourage' people to check what it does
>> before using it
>>
>> __strtobool?
> 
> Ick, no, that implies that no one outside of this file should call it.
> Or it should be called with locks held or some such "special" thing.
> Don't do that...
 I may have gotten a smidgen flippant ;)
> 
> thanks,
> 
> greg k-h
> 

