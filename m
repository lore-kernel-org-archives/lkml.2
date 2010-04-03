Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0DCXxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 19:53:37 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:48846 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0DCXxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 19:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UNTWpQqELX71MfKmshhPoa38BCMH0xv78Caz2tgwT/LCRHZx6+6esYnHPQBgHIew7K
         KM1f4Zv7pmE955Wxph56acBiMlOfuUt3Z2cFYcIFPTDBjUkyr2zpXlyQVucO3gcrJmYl
         7d4SOVo+MU4Duspzcj7/+2oFu+c+9l8cvcg34=
Date: Sat, 3 Apr 2010 16:53:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100403235326.GA23445@core.coreip.homeip.net>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403223328.GA4507@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
> 
> 4) SynPS/2 touchpad: 
> Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
> as the mouse pointer seems to get new data:
>   62,5% (473,1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
> 

80 pps @ 6 bytes/packet = 480 interrupts/sec.

You can try using psmouse.rate=40 to limit it to 40 pps which should
bring it to the rate of standard PS/2 mouse at the expense of
sensitivity...

-- 
Dmitry
