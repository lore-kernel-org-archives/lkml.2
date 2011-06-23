Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab1FWOIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:08:43 -0400
Received: from app1a.xlhost.de ([213.202.242.161]:39962 "EHLO app1a.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab1FWOIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:08:41 -0400
Message-ID: <4E0348E0.7050808@kpanic.de>
Date: Thu, 23 Jun 2011 16:08:32 +0200
From: Stefan Assmann <sassmann@kpanic.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org>
In-Reply-To: <20110623133950.GB28333@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.06.2011 15:39, Matthew Garrett wrote:
> On Wed, Jun 22, 2011 at 01:18:51PM +0200, Stefan Assmann wrote:
>> Following the RFC for the BadRAM feature here's the updated version with
>> spelling fixes, thanks go to Randy Dunlap. Also the code is now less verbose,
>> as requested by Andi Kleen.
>> v2 with even more spelling fixes suggested by Randy.
>> Patches are against vanilla 2.6.39.
>> Repost with LKML in Cc as suggested by Andrew Morton.
> 
> Would it be more reasonable to do this in the bootloader? You'd ideally 
> want this to be done as early as possible in order to avoid awkward 
> situations like your ramdisk ending up in the bad RAM area.

Not sure what exactly you are suggesting here. The kernel somehow needs
to know what memory areas to avoid so we supply this information via
kernel command line.
What the bootloader could do is to allow the kernel/initrd to be loaded
at an alternative address. That's briefly mentioned in the BadRAM
Documentation as well. Is that what you mean or am I missing something?

  Stefan
