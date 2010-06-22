Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0FVHdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:33:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:48424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab0FVHdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:33:13 -0400
Message-ID: <4C2066F1.6070903@kernel.org>
Date: Tue, 22 Jun 2010 09:32:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-13-git-send-email-tj@kernel.org> <4C1F6E5D.5030809@kernel.org> <20100621202719.GA24796@suse.de>
In-Reply-To: <20100621202719.GA24796@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Jun 2010 07:32:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 10:27 PM, Greg KH wrote:
> On Mon, Jun 21, 2010 at 03:51:25PM +0200, Tejun Heo wrote:
>> On 06/13/2010 05:31 PM, Tejun Heo wrote:
>>> Ask IRQ subsystem to watch HCD IRQ line after initialization.  This at
>>> least keeps USB ports which are occupied on initialization working and
>>> eases bug reporting and debugging.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>
>> Greg, if you think the change is okay, can you please ack it?  Also,
>> would it be okay to route this through irq tree?
> 
> Sorry, I thought I did earlier.  Yes, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> and take it through what ever tree you want to :)

Great, thanks. :-)

-- 
tejun
