Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1A0U5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:57:24 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:52598 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892Ab1A0U5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:57:23 -0500
Message-ID: <4D41DC42.3070603@bluewatersys.com>
Date: Fri, 28 Jan 2011 09:57:38 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
References: <20110125235700.GR8008@google.com> <20110126144910.ce0646ec.akpm@linux-foundation.org> <20110126145703.a0f5add5.rdunlap@xenotime.net> <20110126151017.ed9e627c.akpm@linux-foundation.org> <20110127082718.GA4748@p183.telecom.by> <20110127155754.GB8520@google.com> <4D41D963.6020509@bluewatersys.com> <20110127205357.GA4731@p183.telecom.by>
In-Reply-To: <20110127205357.GA4731@p183.telecom.by>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 09:53 AM, Alexey Dobriyan wrote:
> On Fri, Jan 28, 2011 at 09:45:23AM +1300, Ryan Mallon wrote:
>> Why not make printk prefix messages that have no log level with
>> "[NO_LOG_LEVEL]" or similar? That way the can easily be grepped out, and
>> it provides and incentive for people to fix them :-).
> 
> Because printk("foo"); ... printk("\n"); is legit.

It should be fixed to KERN_CONT should it not?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
