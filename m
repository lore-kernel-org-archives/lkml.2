Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2CLSSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:18:36 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:50079 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2CLSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:18:35 -0400
Message-ID: <4F5E3DF9.2000806@tilera.com>
Date: Mon, 12 Mar 2012 14:18:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: remove a non-existing header
References: <1331561930-14964-1-git-send-email-mchehab@redhat.com> <4F5E08C7.9070400@tilera.com> <4F5E0F78.3000308@redhat.com>
In-Reply-To: <4F5E0F78.3000308@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc's trimmed a bit.)

On 3/12/2012 11:00 AM, Mauro Carvalho Chehab wrote:
> Em 12-03-2012 11:31, Chris Metcalf escreveu:
>> On 3/12/2012 10:18 AM, Mauro Carvalho Chehab wrote:
>>> While testing some API changes at the EDAC core, I've tested the EDAC
>>> drivers compilation on all supported architectures, including Tilera.
>>>
>>> I noticed that Tilera upstream code has issues: it doesn't compile with
>>> kernel 3.2:
>>>
>>> In file included from include/linux/linkage.h:5,
>>>                  from include/linux/kernel.h:13,
>>>                  from include/linux/sched.h:55,
>>>                  from arch/tile/kernel/asm-offsets.c:19:
>>> /home/mchehab/redhat/trees/work/new_edac/arch/tile/include/asm/linkage.h:18:22: error: feedback.h: No such file or directory
>>> make[1]: *** [arch/tile/kernel/asm-offsets.s] Error 1
>>>
>>> Without it, it is not possible to compile anything on this archictecture
>>> using this default configuration:
>>> 	./arch/tile/configs/tilegx_defconfig
>>>
>>> Cc: stable@kernel.org
>>> Signed-of-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Thank you, but nack.  The header is provided in the latest gcc tip code. 
> Hmm... the gcc cross-compiler I've downloaded from Tilera site about one month
> ago didn't have it (tilegx-unknown-linux-gnu-gcc (GCC) 4.4.6).

I've refreshed the toolchain pieces on the website, including the x86_64
cross-compiler, so please download the revised one next time you want to
try a build.  Thanks for your patience!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

