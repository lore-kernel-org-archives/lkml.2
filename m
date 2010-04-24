Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0DXQSK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 12:18:10 -0400
Received: from relay.ihostexchange.net ([66.46.182.54]:47312 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0DXQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 12:18:08 -0400
Message-ID: <4BD319B8.1030508@VirtualLogix.com>
Date: Sat, 24 Apr 2010 18:18:00 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: make hub.h, hcd.h public (drivers	dependency),
 linux-2.6.34-rc5
References: <1272121713.23655.63.camel@localhost> <20100424153501.GA11465@kroah.com> <20100424154951.GA11919@kroah.com>
In-Reply-To: <20100424154951.GA11919@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2010 05:49 PM, Greg KH wrote:
> On Sat, Apr 24, 2010 at 08:35:01AM -0700, Greg KH wrote:
>> On Sat, Apr 24, 2010 at 05:08:33PM +0200, Eric Lescouet wrote:
>>> The usbcore headers:hcd.h and hub.h are shared between usbcore,
>>> HCDs and a couple of other drivers (e.g. USBIP modules).
>>> So, it makes sense to move them into a more public location and
>>> to cleanup dependency of those modules on kernel internal headers.
>>> Both are moved into include/linux/usb/
>>
>> Just move one at a time.  Patches should do one thing only.  So this
>> should be at least 2 patches.
>>
>> And I thought you were going to rename hub.h to ch11.h instead?
> 
> Oops, I now see patch 2 :)
> 
> Anyway, how about 3 patches here?  Your last one is fine, but make the
> first one into 2 different ones?  One that does hcd.h and then one that
> does hub.h.

Why not... ;-)

Since I'll do it again, I could use 2.6.34-rc5-git5, as per your request.
I was not so sure how to get the full source for the snapshot...
Should I apply 2.6.34-rc5-git5 patch onto 2.6.34-rc5 tree ?

Thanks,
	Eric.
