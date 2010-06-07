Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0FGVHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:07:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52387 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0FGVHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:07:00 -0400
Message-ID: <4C0D5F56.3060201@zytor.com>
Date: Mon, 07 Jun 2010 14:06:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] [RFC] Save/restore MISC_ENABLE register
References: <201006071814.53583.linux@rainbow-software.org> <201006072051.10421.linux@rainbow-software.org> <4C0D4032.6020907@zytor.com> <201006072305.54829.rjw@sisk.pl>
In-Reply-To: <201006072305.54829.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 02:05 PM, Rafael J. Wysocki wrote:
> On Monday 07 June 2010, H. Peter Anvin wrote:
>> On 06/07/2010 11:51 AM, Ondrej Zary wrote:
>>>
>>> Something like this?
>>>
>>> Save/restore MISC_ENABLE register on suspend/resume.
>>> This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM, which
>>> wakes up with MWAIT disabled.
>>>
>>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>>>
>>
>> Yes, that's a lot better.
>>
>> I presume you have tested it.  Rafael, do you want to take this or should I?
> 
> I can take it.  Is it OK to add your ACK?
> 

Yes.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
