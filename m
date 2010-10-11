Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0JKWrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:47:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57502 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab0JKWrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:47:48 -0400
Message-ID: <4CB393EB.3060405@zytor.com>
Date: Mon, 11 Oct 2010 15:47:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Marcio Saito <marcio@cyclades.com>, Jiri Slaby <jirislaby@gmail.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        John Stultz <johnstul@us.ibm.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH] allow low HZ values?
References: <20101011201121.GA953@tpepper-t61p.dolavim.us> <1286836212.5220.19.camel@pasglop> <alpine.LFD.2.00.1010120032060.2909@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010120032060.2909@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 03:33 PM, Thomas Gleixner wrote:
> On Tue, 12 Oct 2010, Benjamin Herrenschmidt wrote:
> 
>> On Mon, 2010-10-11 at 13:11 -0700, Tim Pepper wrote:
>>> I'm not necessarily wanting to open up the age old question of "what is
>>> a good HZ", but we were doing some testing on timer tick overheads for
>>> HPC applications and this came up...
>>
>> Note that this is also very useful when working on CPU prototypes
>> implemented in FPGAs and running at something like 12Mhz :-)
> 
> /me hands benh 0.5$ for a FPGA upgrade

That's often not possible if the CPU cannot be mapped onto a single FPGA
(either because the core is too large, multiple cores are tested, or
because there is debugging logic is included.)  The interconnects slows
things down tremendously.

	-hpa

