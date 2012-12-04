Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2LDH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:58:45 -0500
Received: from smtp-out-241.synserver.de ([212.40.185.241]:1167 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752055Ab2LDH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:58:41 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4322
Message-ID: <50BDAD3D.9020209@metafoo.de>
Date: Tue, 04 Dec 2012 08:58:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/5] asm-generic/mmu.h: Remove unused vmlist field from
 mm_context_t
References: <1351765467-29244-1-git-send-email-lars@metafoo.de> <201212032354.10573.arnd@arndb.de>
In-Reply-To: <201212032354.10573.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 12:54 AM, Arnd Bergmann wrote:
> On Thursday 01 November 2012, Lars-Peter Clausen wrote:
>> Nothing is using the vmlist field in mm_context_t anymore. It has been removed
>> from the non-generic versions over 3 years ago 8feae1311 ("NOMMU: Make VMAs per
>> MM as for MMU-mode linux").
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Whole series:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Do you want to include the patches in a patch set of your own, or should I put them
> into the asm-generic tree?
> 
> 	Arnd

Hi Arnd,

The plan was to let it go through the asm-generic tree.

Thanks,
- Lars
