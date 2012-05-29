Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2E2Lpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab2E2Lpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:45:40 -0400
Message-ID: <4FC4B6D7.7070100@redhat.com>
Date: Tue, 29 May 2012 08:45:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC v26 00/66] EDAC patches for v3.5
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com> <20120518164615.GY20215@aftab.osrc.amd.com> <4FB68A28.9090205@redhat.com> <20120518175336.GB20215@aftab.osrc.amd.com> <4FC39DB8.7080804@redhat.com> <20120528203655.GA25058@aftab.osrc.amd.com> <4FC4068B.6000903@redhat.com> <4FC4372C.5070300@linux.intel.com>
In-Reply-To: <4FC4372C.5070300@linux.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-05-2012 23:40, Chen Gong escreveu:
> 于 2012/5/29 7:13, Mauro Carvalho Chehab 写道:
>> I'll also add a few other fixup/cleanup patches from v26 that
>> don't affect the core and were reviewed/tested:
>>
>> 0bf09e8 i7core: fix ranks information at the per-channel struct 
>> 486dfb1 i5000: Fix the fatal error handling 9f70d08 i5100_edac: Fix
>> a warning when compiled with 32 bits 36683aa i82975x_edac: Test
>> nr_pages earlier to save a few CPU cycles 805afb6 e752x_edac:
>> provide more info about how DIMMS/ranks are mapped 64e1fda
>> i5000_edac: Fix the logic that retrieves memory information
>>
>> Regards, Mauro -- To unsubscribe from this list: send the line
>> "unsubscribe linux-edac" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>
> 
> Have you included my pending patches for EDAC?, Thx a lot!
> https://lkml.org/lkml/2012/5/8/62
> http://www.spinics.net/lists/linux-edac/msg01396.html

Sorry, it seems I forgot to add them at -next. I'll put them on a separate git pull 
request, likely tomorrow, after testing them.

Regards,
Mauro

