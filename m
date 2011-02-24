Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1BXJPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:15:39 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:49168 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1BXJPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:15:37 -0500
Message-ID: <4D6621AB.10205@ahsoftware.de>
Date: Thu, 24 Feb 2011 10:15:23 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: balbi@ti.com
CC: Alan Stern <stern@rowland.harvard.edu>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Greg KH <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
References: <4D64C81B.5060807@ahsoftware.de> <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org> <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 24.02.2011 09:57, schrieb Felipe Balbi:
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

I can do, I'm using exactly the same patch since yesterday. ;)

Tested-by: Alexander Holler <holler@ahsoftware.de>

Regards,

Alexander

