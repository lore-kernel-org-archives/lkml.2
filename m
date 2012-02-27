Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2B0Ivu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:51:50 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39744 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2B0Ivt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:51:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.37.203 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4B4420.8010309@gmail.com>
Date: Mon, 27 Feb 2012 09:51:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Hugh Dickins <hughd@google.com>, Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Regression: Bad page map in process xyz
References: <1330317933-20196-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1330317933-20196-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 05:45 AM, Naoya Horiguchi wrote:
>> We do still need to get the fix into linux-next: Horiguchi-san, has
>> akpm put your fix in mm-commits yet?  Please send it again if not.
>
> Sorry for late reply.
> And yes, this fix is in mm-commits now.

And in -next too as of today:
commit 57a2e0ac358d580399a63b54fe4275632bbf63f5
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Sat Feb 25 12:28:03 2012 +1100

     fix mremap bug of failing to split thp

thanks,
-- 
js
