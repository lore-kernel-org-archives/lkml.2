Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0IWUAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:00:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59082 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0IWUAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:00:53 -0400
Message-ID: <4C9BB1C5.80808@zytor.com>
Date: Thu, 23 Sep 2010 13:00:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Glove box" BIOS patch causes boot flicker
References: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr> <4C994F0B.6030004@linux.intel.com> <alpine.LNX.2.01.1009232052230.16976@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1009232052230.16976@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 11:54 AM, Jan Engelhardt wrote:
> On Wednesday 2010-09-22 02:34, H. Peter Anvin wrote:
> 
>> There were some minor bugs (typos) in the conversion to the glove box 
>> coding style. The ones we have found have been fixed, so the first 
>> thing is to try the current mainline or the current tip tree.  
>> Otherwise I would look for issues where either the wrong register is 
>> changed, or something like a variable is changed instead of a field.
> 
> I tried v2.6.36-rc5 now, and it looks better. The cursor position is 
> retained as desired. The mode switch is still there, albeit much 
> shorter than it used to be.

The mode switch was there in the original code.

	-hpa

