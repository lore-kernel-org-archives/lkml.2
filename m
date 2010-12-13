Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab0LMPE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:04:58 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:51399 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0LMPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IsBogcKNf+pTSbBZljHz4mcvvql/Ozq1MH5nJkZ6MBY+bWOc6mB1u3ZVP55pYAHzdT
         BCpypozL+we/E7pd2pOOUsceC2R6dm0Oc6bbeZW8Y5fmk3SKLvC1Vi8qqKiw0Ex6eSjr
         PgSuNYbuA5XfujVcbhsdOiu8Gj/b/J2sKHmV4=
Message-ID: <4D063611.7010908@gmail.com>
Date: Mon, 13 Dec 2010 18:04:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?Q1PDiUNTWSBMw6FzemzDsw==?= <boobaa@frugalware.org>
CC: Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, aris@redhat.com,
        peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?VkFKTkEgTWlr?= =?UTF-8?B?bMOzcw==?= 
	<vmiklos@frugalware.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.36 does not boot properly
References: <201012130019.41234.boobaa@frugalware.org>
In-Reply-To: <201012130019.41234.boobaa@frugalware.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 02:19 AM, CSÉCSY László wrote:
> Hi all,
> 
> I have recently upgraded from kernel-2.6.35-5-i686.fpm (which is a 2.6.35.7 
> speaking upstream's terms) to kernel-2.6.36-1-i686.fpm (which is a 2.6.36) on 
> my ASUS K50IJ laptop running Frugalware Linux -current, and it failed to boot 
> when I used the usual command line:
> 
> kernel (hd0,1)/boot/vmlinuz root=/dev/sda2 ro quiet resume=/dev/sda5
> 
> "Failed to boot" means that the thing does not even output even a single 
> character after "[Linux-bzImage, setup=0x3000, size=0x3c5380]" but hangs - 
> even C-A-Del does not do anything (I do have waited for half an hour). 
> Pressing the power button (it does not matter for how long) turns the laptop 
> off immediately.
> 
...

It's weird that bisect pointed to this nmi code snipped movement, I
think the issue in strcmp, and in event_create_dir. Better to
CC Steven.

-- 
    Cyrill
