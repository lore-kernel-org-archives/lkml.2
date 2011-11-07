Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1KGUpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:45:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45273 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1KGUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:45:53 -0500
Message-ID: <4EB8436B.20603@zytor.com>
Date: Mon, 07 Nov 2011 12:45:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org> <20111107202324.GA27515@srcf.ucam.org> <4EB8413D.6030500@zytor.com> <20111107203752.GA27875@srcf.ucam.org>
In-Reply-To: <20111107203752.GA27875@srcf.ucam.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 12:37 PM, Matthew Garrett wrote:
> On Mon, Nov 07, 2011 at 12:36:13PM -0800, H. Peter Anvin wrote:
> 
>> Yes, I think it makes a lot of sense.  If we need to introduce new
>> meta-types to deal with the fact that there are EFI types that don't map
>> to E820, then so be it... and this is *exactly* why we want the EFI
>> setup stub to be part of the kernel image and not off in a separate
>> bootloader, requiring a stable interface...
> 
> I don't disagree, it's just going to be an absolute pain to manage that 
> in a secure boot world.

Could you clarify, please?

> Looking at the code, we actually already seem to 
> have decided to start just making up E820 types, so maybe we should just 
> do that... 

That's what I just said, no?  I think we use negative numbers for those.

	-hpa

