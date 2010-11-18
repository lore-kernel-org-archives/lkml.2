Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0KRCtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:49:16 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:37333 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0KRCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:49:15 -0500
Message-ID: <4CE49503.90607@wytron.com.tw>
Date: Thu, 18 Nov 2010 10:52:51 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH] gen_init_cpio: remove leading `/' from file names
References: <1286349233-31721-1-git-send-email-thomas@wytron.com.tw> <AANLkTikN_B-xq=Ge1gx-T5356K5ULd7u11y-mmS=BXMO@mail.gmail.com>
In-Reply-To: <AANLkTikN_B-xq=Ge1gx-T5356K5ULd7u11y-mmS=BXMO@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Michal,

On 10/06/2010 10:51 PM, Mike Frysinger wrote:
> On Wed, Oct 6, 2010 at 03:13, Thomas Chou wrote:
>> When we extracted the generated cpio archive using "cpio -id" command,
>> it complained,
>>
>> cpio: Removing leading `/' from member names
>> var/run
>> cpio: Removing leading `/' from member names
>> var/lib
>> cpio: Removing leading `/' from member names
>> var/lib/misc
>>
>> It is worse with the latest "cpio" or "pax", which tries to overwrite
>> the host file system with the leading '/'.
>
> seems to work as intended on Blackfin systems, and i cant see any
> reason to require the leading slash, so:
> Acked-by: Mike Frysinger<vapier@gentoo.org>
> -mike
>
>

Would you please review this patch? It is not clear as who should handle 
this with the MAINTAINERS.

Best regards,
Thomas
