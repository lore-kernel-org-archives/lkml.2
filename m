Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab2BJDJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:09:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2BJDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:09:46 -0500
Message-ID: <4F348A70.4080604@gmail.com>
Date: Fri, 10 Feb 2012 11:09:36 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + proc-clean-up-proc-pid-environ-handling.patch added to -mm
 tree
References: <20120208151516.GA15570@redhat.com>
In-Reply-To: <20120208151516.GA15570@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 11:15 PM, Oleg Nesterov wrote:
>> From: Cong Wang<xiyou.wangcong@gmail.com>
>> Subject: proc: clean up /proc/<pid>/environ handling
>>
>> Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
>> handling"),
>
> and has the same problem,
>
>> move the check of permission to open(), this will simplify
>> read() code.
>
> but allows to kill the system trivially.
>
> Please look at 6d08f2c7139790c268820a2e590795cb8333181a
> "proc: make sure mem_open() doesn't pin the target's memory"
>

Thanks, I wasn't aware of that commit. I will send an updated patch soon.

