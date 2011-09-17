Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1IQPNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:13:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33823 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1IQPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:13:30 -0400
Message-ID: <4E74B7A9.1070001@gmail.com>
Date: Sat, 17 Sep 2011 17:07:21 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xip: export xip_file_fault
References: <4E749003.30909@gmail.com> <20110917135346.GA31551@infradead.org>
In-Reply-To: <20110917135346.GA31551@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/09/2011 15:53, Christoph Hellwig ha scritto:
> On Sat, Sep 17, 2011 at 02:18:11PM +0200, Marco Stornelli wrote:
>> From: Marco Stornelli<marco.stornelli@gmail.com>
>>
>> There aren't sufficient sync points for a fs for xip operations. In
>> particular for the mmap case. It can be not sufficient to lock/unlock
>> to do some operation inside get_xip_mem callback. For xip_file_read
>> it's really easy to write a fs specific wrapper, xip_file_write hold
>> i_mutex so no problem. With this patch it's possible to reuse the
>> generic xip_file_fault, using a wrapper function in a fs, without to
>> reinvent the wheel.
>
> As usual please send patches to add exports only while adding callers
> for it.
>
>

Actually the module is not currently in mainline even if I hope soon. No 
problem. I'll resend it at the right moment.

Marco
