Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2KLDEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:04:24 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43405 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2KLDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:04:22 -0500
Message-ID: <50A0672C.6030808@linux.vnet.ibm.com>
Date: Mon, 12 Nov 2012 11:04:12 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule)
References: <56378024.A3Kec8xZj0@pawels>
In-Reply-To: <56378024.A3Kec8xZj0@pawels>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12111203-5140-0000-0000-000002591748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 09:48 PM, Paweł Sikora wrote:
> Hi,
> 
> during playing with new ups i've caught an nice oops on reboot:
> 
> http://imgbin.org/index.php?page=image&id=10253
> 
> probably the upstream is also affected.

Hi, Paweł

Are you using a clean 3.6.6 without any modify?

Looks like some threads has set itself to be UNINTERRUPTIBLE with out
any design on switch itself back later(or the time is too long), are you
accidentally using some bad designed module?

BTW, it's better to paste whole log in mail with text style not a picture.

Regards,
Michael Wang

> 
> BR,
> Paweł.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

