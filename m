Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1LBPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:11:10 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:64032 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1LBPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:11:08 -0500
Message-ID: <4ED8EA8A.2050900@tilera.com>
Date: Fri, 2 Dec 2011 10:11:06 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] asm-generic/unistd.h: support new process_vm_{readv,write}
 syscalls
References: <201112011815.pB1IFACw004908@farm-0002.internal.tilera.com> <12496289.FSF46xab1G@wuerfel>
In-Reply-To: <12496289.FSF46xab1G@wuerfel>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/2011 5:48 PM, Arnd Bergmann wrote:
> On Thursday 01 December 2011 12:54:31 Chris Metcalf wrote:
>> Also prototype the "compat" functions so they can be referenced
>> from C code.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>>  include/asm-generic/unistd.h |    8 +++++++-
>>  include/linux/compat.h       |    9 +++++++++
>>  2 files changed, 16 insertions(+), 1 deletions(-)
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Chris, I don't have any other patches for asm-generic right now. Can you handle
> this through the tile tree?

I will.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

