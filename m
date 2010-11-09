Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab0KIKf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:35:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34942 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab0KIKfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:35:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HodAHA8oh4VAovWqUqoWwQsamg3gH3LIJ5uK3KVqZffQQyxDsc7VKH+fjWjrqUI4BZ
         XCjGdlxi8NQWDSDTDPXIKUPIP/UgXbS+UIGnCl5XJNMvkIOpnubSC9dWH0Xu+tAw10Lj
         WasbtJCdlnJ2CoYEc3GNC73QzY8j9qV1EISBM=
Date: Tue, 9 Nov 2010 18:40:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: JD <jd1008@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question/help re: themake scripts in 2.6.36
Message-ID: <20101109104037.GJ5220@cr0.nay.redhat.com>
References: <4CD63067.8010506@gmail.com>
 <20101107074213.GL3046@hack>
 <4CD73A04.5020604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CD73A04.5020604@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 03:45:08PM -0800, JD wrote:
>On 11/07/2010 12:42 AM, Américo Wang wrote:
>>On Sat, Nov 06, 2010 at 09:51:51PM -0700, JD wrote:
>>>I have compiled 2.6.36 (i686) without any problems.
>>>Since then, I have decided to change a couple of
>>>config variables (using xconfig).
>>
>>You can use 'make oldconfig'.
>>
>>>When done, running make all
>>>causes the make scripts to stop compilation after building
>>>a few objects, and spawn a shell.
>>>Since I have no idea what to do in that shell, I exit
>>>that shell, and the compilaton continues.
>>>This takes place 3 times before compilation is complete.
>>>
>>
>>What? How can make spawn a shell...
>>
>>Can you copy and paste what you see and what you get
>>from your terminal?
>I have attached make.out.xz
>(compressed with lzma).
>
>Look for exit
>because I had to exit the shell that gets forked in order to
>let make continue.
>

Well, that is not due to make, it is because you
used su -c 'make install modules_install'. :)

Try su -c 'make install && make modules_install'.

