Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1ABWJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:09:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44788 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1ABWJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TNh/bu90TqqEKW55ysScsl7oj8mdEm6NaIqV/b+tDDnYQ/nRBECj9DgJsW0EmSIInW
         wicBSNib9j+LjbGZNXVnHb2a9moBGhDYc2cGm5pnsEuINETba9zVaNBbHTb3UPiF+P58
         kbZqQOUhTTiQI5PgPb/TQCBwSQjqXDzzCfEOs=
MIME-Version: 1.0
In-Reply-To: <20110102203023.GA1545@ucw.cz>
References: <20110102204532.GA12860@elf.ucw.cz>
	<20110102203023.GA1545@ucw.cz>
Date: Sun, 2 Jan 2011 23:09:36 +0100
Message-ID: <AANLkTika7HAEc+BbqSnbo8viUt4nOqoeB69qWZs85-9s@mail.gmail.com>
Subject: Re: zaurus bluetooth regression
From: Yegor Yefremov <yegorslists@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>> It seems this commit
>>
>> commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
> ...
>> ...is responsible for my bluetooth problems on zaurus -- at least
>> bisect pointed to it,  as I use 16C950-based bluetooth card, it seems
>> very logical. I'll try 2.6.37-rc8 with that patch reverted...
>>
>
> And yes, 37-rc8 with that reverted results in working bluetooth, so
> yrs, that patch is responsible.

could you tell, what kind of problem you're encountering and if you
could tell, which flag UART_CAP_EFR or UART_CAP_SLEEP causes the
problem?

Yegor
