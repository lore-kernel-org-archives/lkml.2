Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2E1M0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:26:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2E1M0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:26:10 -0400
Message-ID: <4FC36EDA.6020707@gmail.com>
Date: Mon, 28 May 2012 20:26:02 +0800
From: yuq <yuq825@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Run RTOS simultaneously with Linux
References: <4FC2EF4B.5020207@gmail.com> <CAJd=RBAQR_h437ZGU7K=7=dnd-joBkGNc_oGaQ1z8_3cAPLLWA@mail.gmail.com>
In-Reply-To: <CAJd=RBAQR_h437ZGU7K=7=dnd-joBkGNc_oGaQ1z8_3cAPLLWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact my modification to Linux kernel is a separate loadable kernel 
module. It also includes a user space monitor and RTOS file system 
server, RTOS image is also a loadable file. You can get it from my rep:

RGMP, an early version for porting existing RTOS like Nuttx and UCOS to 
run with Linux. Besides Linux loadable module and Linux user space 
monitor, it has a static library for
RTOS to link with:

git://rgmp.git.sourceforge.net/gitroot/rgmp/rgmp

YUQIX, an advance version which has Linux side RTOS file system server 
and my experimental RTOS for advanced real-time applications:

git://rgmp.git.sourceforge.net/gitroot/rgmp/yuqix

yuq

On 05/28/2012 07:55 PM, Hillf Danton wrote:
> Hi yuq
>
> On Mon, May 28, 2012 at 11:21 AM, yuq<yuq825@gmail.com>  wrote:
>> Hi all,
>>
>> I have done some work about running some RTOS simultaneously with Linux, the
>> approach is running RTOS and Linux on different CPU cores. No modification
>> to Linux kernel but adding a loadable kernel module. I post it at
>> http://rgmp.sf.net
>>
>> I want to know how you guys think about it. Any advice is welcome.
>>
> I want to see your work, would you please post it on LMKL in
> (monolithic) diff format?
>
> Thanks
> -hd

