Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2HQKMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:12:31 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33588 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab2HQKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120817100729.GF24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-10-git-send-email-catalin.marinas@arm.com>
 <502E1580.70702@ti.com> <20120817100729.GF24389@arm.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 17 Aug 2012 15:42:07 +0530
Message-ID: <CAMQu2gz1A5VCTFS_7vzBhnaLhbEKUOhpH-KfFbrE6YhaLDDxXA@mail.gmail.com>
Subject: Re: [PATCH v2 09/31] arm64: Cache maintenance routines
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:37 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Aug 17, 2012 at 10:57:20AM +0100, Santosh Shilimkar wrote:
>> On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
>> > +ENTRY(__cpuc_flush_dcache_all)
>>
>> We have discussed the need of cache maintenance by
>> level kind of API for ARMv7 (A15).
>>
>> Shouldn't we add such API for arm64 as well ?
>
> Yes, at some point we'll probably add but we'll discuss it again when
> actually needed. I wouldn't define new API now that's not used by any
> AArch64 code.
>
The patches are already on the list for ARMv7 and just waiting to merge
two approaches.
I agree once it is getting merged for ARMv7 and ARMv8 port can be
updated.

Regards
Santosh
