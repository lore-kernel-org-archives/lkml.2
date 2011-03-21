Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1CUSli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:41:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:33311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1CUSlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:41:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,220,1299484800"; 
   d="scan'208";a="899598579"
Message-ID: <4D879BDF.3060004@intel.com>
Date: Mon, 21 Mar 2011 11:41:35 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Jiang, Dave" <dave.jiang@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Danecki, Jacek" <jacek.danecki@intel.com>,
        "Ciechanowski, Ed" <ed.ciechanowski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmilburn@redhat.com" <dmilburn@redhat.com>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6> <20110318225016.GB15921@suse.de> <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com> <20110319002246.GB14249@suse.de> <4D8403C3.6020300@intel.com> <20110320001459.GA9237@suse.de>
In-Reply-To: <20110320001459.GA9237@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2011 5:14 PM, Greg KH wrote:
> On Fri, Mar 18, 2011 at 06:15:47PM -0700, Dan Williams wrote:
>> On 3/18/2011 5:22 PM, Greg KH wrote:
>>> On Fri, Mar 18, 2011 at 04:10:10PM -0700, Dan Williams wrote:
>>>>> I needed all patches in linux-next _before_ the merge window opened to
>>>>> be able to accept it.
>>>>
>>>> Yes, I know, and as dmaengine maintainer I also hate being ambushed by
>>>> last minute patches, but now I am unfortunately one of those annoying
>>>> people on the other side of the coin.
>>>
>>> Then you should know better than to try to go around the well-known
>>> rules :)
>>
>> Yes...
>>
>> /me about to push his luck
>
> <snip>
>
>> As Jeff pointed out:
>> "It seemed like this was turning into another driver that would get
>> held outside the kernel until it's "perfect."  If that is the case,
>> Linus has also made it clear we should get drivers for high volume,
>> shipping hardware into the kernel, even if its staging, if the
>> alternative is to deny users the driver."
>
> That's fine, _BUT_ you are trying to go around the rules for the merge
> window, which isn't acceptable.   Also note that your driver isn't
> self-contained, it needs this change at the least, right?  Any others?

This efi export was a late discovery, we tried to use the existing 
exports (raw efi runtime services) but it was not clean (needed to 
duplicate utf-8 encoding in the driver).  The other external changes/bug 
fixes needed for this driver were submitted weeks ago.

>> So yes, we are targeting that exception.  I'm up for taking the heat
>> directly if you want...  because the pull request will need to
>> backed up with justification.
>
> No, sorry, I'll not take this for .40, all of my trees are merged with
> Linus now for .40 and I'll only be sending him bugfixes until the .41
> merge window opens up.
>
> Remember, it's only a 3 month wait, you knew about this _WAY_ in
> advance, so it's not like this is something new, or out of the ordinary
> at all.  Because of that, I fail to see why this is somehow not
> expected.

Yes, we knew about this way in advance, we brought you in too late for a 
.39-staging discussion.  Appreciate the consideration and understand the 
outcome.

--
Dan
