Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1ATTLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:11:36 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:27269 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1ATTLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:11:34 -0500
Message-ID: <4D3888E4.1020108@tilera.com>
Date: Thu, 20 Jan 2011 14:11:32 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 36/37] tile: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de> <20110119210840.631350392@linutronix.de> <4D3884E3.8050009@tilera.com> <20110120190818.GA22638@merkur.ravnborg.org>
In-Reply-To: <20110120190818.GA22638@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2011 2:08 PM, Sam Ravnborg wrote:
> On Thu, Jan 20, 2011 at 01:54:27PM -0500, Chris Metcalf wrote:
>> On 1/19/2011 4:50 PM, Thomas Gleixner wrote:
>>> No functional change.
>>>
>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>>> ---
>>>  arch/tile/Kconfig |   16 ++++++----------
>>>  1 file changed, 6 insertions(+), 10 deletions(-)
>>>
>>> Index: linux-2.6/arch/tile/Kconfig
>>> ===================================================================
>>> --- linux-2.6.orig/arch/tile/Kconfig
>>> +++ linux-2.6/arch/tile/Kconfig
>>> @@ -1,22 +1,18 @@
>>>  # For a description of the syntax of this configuration file,
>>>  # see Documentation/kbuild/config-language.txt.
>>>  
>>> +config TILE
>>> +       def_bool y
>>> +       select HAVE_GENERIC_HARDIRQS
>>> +       select GENERIC_IRQ_PROBE
>>> +       select GENERIC_PENDING_IRQ if SMP
>>> +
>>>  [...]
>> I'm not sure it's legal to have two "config TILE" blocks in this Kconfig
>> file; there's already one further down.
> It is OK to have two "config TILE" blocks.
> You should take care of moving the other one up after this goes in.

In that case I'm happy to ack the original patch.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

