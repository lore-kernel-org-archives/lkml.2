Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3AIQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:06:01 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56774 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab3AIQF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:05:59 -0500
Message-ID: <50ED9525.9040806@imgtec.com>
Date: Wed, 9 Jan 2013 16:04:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 24/40] metag: DMA
References: <1351700061-7203-1-git-send-email-james.hogan@imgtec.com> <50AF9C06.3010705@imgtec.com> <50AFA24D.4030501@imgtec.com> <201211231647.27260.arnd@arndb.de>
In-Reply-To: <201211231647.27260.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_09_16_05_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/12 16:47, Arnd Bergmann wrote:
> On Friday 23 November 2012, James Hogan wrote:
>> Subject: [PATCH 1/1] asm-generic/io.h: check CONFIG_VIRT_TO_BUS
>>
>> Make asm-generic/io.h check CONFIG_VIRT_TO_BUS before defining
>> virt_to_bus() and bus_to_virt(), otherwise it's easy to accidentally
>> have a silently failing incorrect direct mapped definition rather then
>> no definition at all.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> 
> Good catch!
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 

Hi Arnd,

Would you like me to include this in the meta patchset or is it okay for
you to take it through the asm-generic tree? (I can resend separately if
you like)

Thanks
James

