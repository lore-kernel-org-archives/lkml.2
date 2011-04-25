Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1DYXLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:11:01 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:2943 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753073Ab1DYXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:11:00 -0400
Message-ID: <4DB5FF87.1060502@bluewatersys.com>
Date: Tue, 26 Apr 2011 11:11:03 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new strtobool
References: <a> <1303213427-12798-3-git-send-email-jic23@cam.ac.uk> <4DADF0D3.3040006@bluewatersys.com> <4DAEA862.5040507@cam.ac.uk> <20110425225437.GA31808@kroah.com>
In-Reply-To: <20110425225437.GA31808@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 10:54 AM, Greg KH wrote:
> On Wed, Apr 20, 2011 at 10:33:22AM +0100, Jonathan Cameron wrote:
>> On 04/19/11 21:30, Ryan Mallon wrote:
>>> On 04/19/2011 11:43 PM, Jonathan Cameron wrote:
>>>> No functional changes requires that we eat errors from strtobool.
>>>> If people want to not do this, then it should be fixed at a later date.
>>>
>>> May as well fix it now or it will get forgotten about. A second patch on
>>> top of this can fix the bug.
>> What worries me about this 'fix' is that it may well break some 'interesting'
>> bit of userspace code.  It would count as a userspace api change, be it
>> a fairly minor one.
>>
>> Greg, do you thing it's worth returning an error on a non bool value?
> 
> No one has ever complained about it, so I doubt it's a big issue.

Probably because nobody checks for errors in user space :-p

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
