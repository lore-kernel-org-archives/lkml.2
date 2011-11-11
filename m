Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1KKPzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:55:02 -0500
Received: from mail.windriver.com ([147.11.1.11]:64503 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1KKPy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:54:59 -0500
Message-ID: <4EBD4511.8010800@windriver.com>
Date: Fri, 11 Nov 2011 10:53:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        Sonic Zhang <sonic.zhang@analog.com>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blackfin: Fixup export.h includes
References: <1321005998-17407-1-git-send-email-lars@metafoo.de> <CAA_GA1cqV9aRtWwrTCG_Yu54js+DnCMeUE94xuN6+_9YTfmX5w@mail.gmail.com>
In-Reply-To: <CAA_GA1cqV9aRtWwrTCG_Yu54js+DnCMeUE94xuN6+_9YTfmX5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-11 05:54 AM, Bob Liu wrote:
> On Fri, Nov 11, 2011 at 6:06 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> Commit 8dc7a9c84 ("blackfin: Add export.h to files using
>> EXPORT_SYMBOL/THIS_MODULE") inserted some of the include statements into
>> sections protected by an unrelated #if CONFIG_... statement. This can cause,
>> depending on the configuration used, warnings like this one:
>>
>>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: data definition has no type or storage class
>>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
>>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: parameter names (without types) in function declaration
>>
>> This patch fixes it by moving the includes out of the #if protected sections.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

[...]

>>
> 
> Thanks!  I'll pick it.
> 
> Acked-by: Bob Liu <lliubbo@gmail.com>

Looks fine to me as well.  I'm assuming it will make it in
tree via Bob, as per above.

Thanks,
Paul.

> 
