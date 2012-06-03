Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab2FCDNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 23:13:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57543 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab2FCDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 23:13:18 -0400
Message-ID: <4FCAD63D.7070604@zytor.com>
Date: Sat, 02 Jun 2012 20:13:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jordan Justen <jordan.l.justen@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [GIT PULL] x86/efi changes for v3.5
References: <20120523075433.GA12526@gmail.com> <20120602183827.GA4020@polaris.bitmath.org>
In-Reply-To: <20120602183827.GA4020@polaris.bitmath.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2012 11:38 AM, Henrik Rydberg wrote:
> Hi Ingo, Hans Peter, Matt, Jordan,
> 
>> This patchset makes changes to the bzImage EFI header, so that 
>> it can be signed with a secure boot signature tool. It should 
>> not affect anyone who is not using the EFI self-boot feature in 
>> any way.
> 
> Commit 2e064b1 (Fix issue of overlapping .reloc section for EFI_STUB)
> breaks EFI boot on my MacBookAir3,1. The efi firmware no longer
> recognizes the bzImage and falls back to BIOS emulation boot.
> 
> Reverting 2e064b1 works for me, but I am happy to test other options
> as well.
> 

Matt, Jordan,

Could you look into this please?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

