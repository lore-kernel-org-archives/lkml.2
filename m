Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab2IET4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:56:31 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:36197 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab2IET43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:56:29 -0400
Message-ID: <5047AE6B.6090508@tilera.com>
Date: Wed, 5 Sep 2012 15:56:27 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, <linux-arch@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208161237.53594.arnd@arndb.de> <20120821160653.GH12708@arm.com> <201208212017.08110.arnd@arndb.de>
In-Reply-To: <201208212017.08110.arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 4:17 PM, Arnd Bergmann wrote:
> On Tuesday 21 August 2012, Catalin Marinas wrote:
>> On Thu, Aug 16, 2012 at 01:37:53PM +0100, Arnd Bergmann wrote:
>>> No, the uname output is meant to tell you about the system, not the
>>> instruction set that you are using (you already know that in compiled
>>> code).
>>
>> OK, so we assumed that compat tasks should get a uname as close as
>> possible to a 32-bit system, i.e. armv8l, for full compatibility. This
>> would allow us to run something like 32-bit Debian on an AArch64 kernel
>> without worrying about any scripts failing.
> 
> You can still do that, just boot with init="/sbin/setarch armv7 /sbin/init".
> 
>> But I can see on x86 that it always reports x86_64 even if the task is
>> x86_32.
> 
> Not just x86, the same behavior is used on powerpc, s390, mips, sparc and
> parisc. Not sure about tile though.

tile also reports "tilegx" regardless of whether the task is 64-bit or
32-bit compat.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
