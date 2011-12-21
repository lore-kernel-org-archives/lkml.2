Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1LUVTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:19:42 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:50311 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754134Ab1LUVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:19:40 -0500
Message-ID: <4EF25B7D.8080905@xenotime.net>
Date: Wed, 21 Dec 2011 14:19:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: fix renesas mod_gadget printk format warning
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au> <4EF2424D.4020200@xenotime.net> <20111221211624.GB17951@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111221211624.GB17951@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 01:16 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Dec 21, 2011 at 12:32:13PM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix printk format warning:
>>
>> drivers/usb/renesas_usbhs/mod_gadget.c:188:3: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> a bit too late:
> 
> http://git.kernel.org/?p=linux/kernel/git/balbi/usb.git;a=commitdiff;h=8418153a4ccd38a3bc3229bc4bd161e3e5db88d2
> 

OK, that's good.  But it's not in linux-next yet??

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
