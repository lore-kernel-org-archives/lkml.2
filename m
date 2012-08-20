Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2HTU1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:27:52 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38742 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754172Ab2HTU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:27:48 -0400
Message-ID: <50329DBF.9060206@xenotime.net>
Date: Mon, 20 Aug 2012 13:27:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: [PATCH] USB: Build usb_speed_string unconditionally
References: <1345491508-30966-1-git-send-email-andi@firstfloor.org> <Pine.LNX.4.44L0.1208201541520.1182-100000@iolanthe.rowland.org> <20120820195808.GD4461@tassilo.jf.intel.com>
In-Reply-To: <20120820195808.GD4461@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/12 12:58, Andi Kleen wrote:

> On Mon, Aug 20, 2012 at 03:47:48PM -0400, Alan Stern wrote:
>> On Mon, 20 Aug 2012, Andi Kleen wrote:
>>
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> The usb core uses usb_speed_string(). But it's only selected
>>> for USB_GADGET. Enable it unconditionally.
>>
>> What are you talking about?  USB_COMMON isn't selected at all, but it
>> does get built whenever USB or USB_GAGDET is enabled.  From
>> drivers/usb/Kconfig:
> 
> Just trying to fix my LTO randconfigs.
> 
> Here's a config that violated it on rc2.


Involves known problem with DRM_USB AFAICT.

Greg just accepted a patch from Guenter Roeck that should
fix this:
[PATCH RESEND] gpu/mfd/usb: Fix USB randconfig problems

-- 
~Randy
