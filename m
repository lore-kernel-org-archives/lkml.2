Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1BXJ7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:59:44 -0500
Received: from mail1.matrix-vision.com ([78.47.19.71]:48503 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1BXJ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:59:43 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 04:59:43 EST
Message-ID: <4D662A9E.90007@matrix-vision.de>
Date: Thu, 24 Feb 2011 10:53:34 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: balbi@ti.com
CC: Alan Stern <stern@rowland.harvard.edu>,
        Alexander Holler <holler@ahsoftware.de>, Greg KH <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
References: <4D64C81B.5060807@ahsoftware.de> <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org> <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MV-Disclaimer: true (erinome)
X-AV-Checked: ClamAV using ClamSMTP (erinome)
X-AV-Checked: ClamAV using ClamSMTP (mail1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 09:57 AM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Feb 23, 2011 at 10:26:20AM -0500, Alan Stern wrote:
>> In both cases, it appears that the problem is caused by the fact that 
>> the musb host-controller driver doesn't set the hcd->has_tt flag.
>>
>> Felipe, you should know where it belongs.  It should be easy enough to 
>> add.
> 
> Sure Alan, it's attached to this mail. Compile tested only though.
> Michael, would you care to give your tested-by ?
> 

Alexander already did, but I can do now, too.  Thanks for the fix.

Tested-by: Michael Jones <michael.jones@matrix-vision.de>

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
