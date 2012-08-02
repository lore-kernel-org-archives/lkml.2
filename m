Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2HBOTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2HBOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:19:33 -0400
Message-ID: <501A8C68.9030001@redhat.com>
Date: Thu, 02 Aug 2012 17:19:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] kbuild: kvm: make export of linux/kvm_para.h unconditional
References: <1343310254-7493-1-git-send-email-will.deacon@arm.com> <20120802122550.GD9838@mudshark.cambridge.arm.com>
In-Reply-To: <20120802122550.GD9838@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 03:25 PM, Will Deacon wrote:
> On Thu, Jul 26, 2012 at 02:44:14PM +0100, Will Deacon wrote:
>> The asm-generic version of kvm_para.h is always exported, confusing the
>> Kbuild wildcarding that tries to detect whether the source architecture
>> is exporting the header, since asm-* matches the generic version.
>> 
>> This patch unconditionally exports linux/kvm_para.h and fixes the few
>> remaining architectures without asm/kvm_para.h to use the generic
>> version. I also took the liberty of removing some dead lines from the
>> wildcarding which was searcing for asm-$(SRCARCH) directores under
>> $(srctree).
>> 
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Avi Kivity <avi@redhat.com>
>> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>> ---
> 
> Any further comments on this? It fixes header generation for me, so it would
> be nice to see it merged.

Can you get it reviewed by someone who is familiar with this?  This is
probably the third fix for the this issue.

Arnd?

-- 
error compiling committee.c: too many arguments to function
