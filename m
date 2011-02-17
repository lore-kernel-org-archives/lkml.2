Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1BQWwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:52:40 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:1584 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169Ab1BQWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:52:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAKs0XU1Ld/sX/2dsb2JhbAAMhBPOE5BLgSeDQXYEhQo
X-IronPort-AV: E=Sophos;i="4.62,182,1297054800"; 
   d="scan'208";a="92042178"
Message-ID: <4D5DA6B0.5080902@teksavvy.com>
Date: Thu, 17 Feb 2011 17:52:32 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Jeff Garzik <jeff@garzik.org>, Joerg Dorchain <joerg@dorchain.net>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: [Patch] enable AHCI mode on certain ich chipsets
References: <20110216090548.GQ5778@Redstar.dorchain.net> <4D5C2974.4070608@garzik.org> <20110217163649.GC20662@srcf.ucam.org>
In-Reply-To: <20110217163649.GC20662@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-02-17 11:36 AM, Matthew Garrett wrote:
> On Wed, Feb 16, 2011 at 02:45:56PM -0500, Jeff Garzik wrote:
> 
>> How is the assignment of the AHCI BAR handled?  Does this happen  
>> automatically because it's an early fixup?
>>
>> That is traditionally the stumbling block...
> 
> Yes, because it's an early fixup the kernel should allocate it itself. 
> It's small enough that I'd hope we don't have trouble finding one...


It works here (the AHCI BAR setup) with this patch,
though the workaround itself doesn't work because my
Dell machine requires extra/secret fiddling to switch
things fully over to AHCI.

The patch does seem harmless enough to include in the kernel, though.
