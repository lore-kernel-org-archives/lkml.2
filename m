Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0KEN4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:56:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40704 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0KEN4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:56:02 -0400
Date: Fri, 5 Nov 2010 15:56:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Balbi, Felipe" <balbi@ti.com>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/39] drivers/usb/musb: Update WARN uses
Message-ID: <20101105135621.GE1818@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1288471897.git.joe@perches.com>
 <a2c75704fe694635912f079c6adab850d3e72559.1288471898.git.joe@perches.com>
 <20101105114435.GL1952@legolas.emea.dhcp.ti.com>
 <alpine.LNX.2.00.1011050953530.15851@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011050953530.15851@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 08:54:20AM -0500, Jiri Kosina wrote:
>On Fri, 5 Nov 2010, Felipe Balbi wrote:
>
>> > Align arguments.
>> >
>> > Signed-off-by: Joe Perches <joe@perches.com>
>>
>> please re-send this when we get closer to .38 merge window. I'm only
>> queueing fixes now.
>
>If you Ack the patch, I can take care of it in trivial queue.

Cool, thanks, here it goes:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
