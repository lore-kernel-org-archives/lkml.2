Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2DBP7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:59:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2DBP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:59:35 -0400
Message-ID: <4F79CCE1.4040709@nod.at>
Date: Mon, 02 Apr 2012 17:59:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 2 (uml)
References: <20120402135538.502e6c73f0cb3e6ae0b3436f@canb.auug.org.au> <4F79C68C.1070100@xenotime.net>
In-Reply-To: <4F79C68C.1070100@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.04.2012 17:32, Randy Dunlap wrote:
> On 04/01/2012 08:55 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> The merge window has closed, so -next is open for busniess.
>>
>> Changes since 20120330:
>
>
>
> uml defconfig on x86_64:
>
>    CC      arch/um/drivers/mconsole_kern.o
> arch/um/drivers/mconsole_kern.c: In function 'stack_proc':
> arch/um/drivers/mconsole_kern.c:707:2: error: implicit declaration of function 'switch_to'
> make[2]: *** [arch/um/drivers/mconsole_kern.o] Error 1
>
>

Already fixed:
http://comments.gmane.org/gmane.linux.kernel/1274493

Thanks,
//richard

