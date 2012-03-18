Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2CROeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 10:34:01 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:25955 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2CROd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 10:33:59 -0400
Message-ID: <4F65F255.5070504@bfs.de>
Date: Sun, 18 Mar 2012 15:33:57 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] x86, efi: fix pointer math issue in handle_ramdisks()
References: <20120305180614.GA26880@elgon.mountain> <4F550917.9020508@bfs.de> <4F551504.5010401@zytor.com> <4F55CE54.4000300@bfs.de> <4F639AB0.7010208@zytor.com>
In-Reply-To: <4F639AB0.7010208@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 16.03.2012 20:55, schrieb H. Peter Anvin:
> On 03/06/2012 12:44 AM, walter harms wrote:
>>>
>> hi,
>>
>> yep, but i was asking about efi. The basic idea is of cause to map efi_char16_t -> wchar_t
>> and back and make this a prototype for every driver that needs a special charset.
>> That would make it possible to recycle the wcs* interface of libc.
>> IMHO it seems more reasonable than adding one for each (upcoming) type.
>>
> 
> Actually libc and the C standard is going the opposite ways, adding new
> interfaces for UTF-16 and UTF-32.  The wchar_t interface just doesn't
> work very well.
> 

I admit i do not have the problem yet and i do not like the idea adding even more types.
Oh well may i should be happy that someone is actually thinking about this here and not
simply add yet on other hot fix.

re,
 wh
