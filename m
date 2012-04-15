Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2DOMKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:10:04 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49281 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab2DOMKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
	<CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com>
	<1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 14:10:00 +0200
Message-ID: <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 1:47 PM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
> Moreover, this is mainly meant for mobile phones where there is only *one* user.

I see. Jet another awful hack.
Mobile phones are nothing special. They are computers.

>>
>> If we expose it to user space *every* program/user will try too free
>> memory such that it
>> can use more.
>> Can you see the problem?
>>
> As indicated above, every program/user cannot use it, as it requires root privileges.
> Ok, you mean to say, every driver can call "shrink_all_memory" simultaneously??
> Well, we can implement locking for that.
> Anyways, I wrote a simple script to do this (echo 512 > /dev/shrinkmem) in a loop for 20 times from 2 different terminal (as root) and it works.
> I cannot see any problem.

Every program which is allowed to use this interface will (ab)use it.
Anyway, by exposing this interface to user space (or kernel modules)
you'll confuse the VM system.

-- 
Thanks,
//richard
