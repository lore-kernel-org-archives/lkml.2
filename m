Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1KGQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:30:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:45243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab1KGQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:30:20 -0500
Message-ID: <4EB80788.9080305@windriver.com>
Date: Mon, 7 Nov 2011 11:30:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: <linux-mtd@lists.infradead.org>, David Woodhouse <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>, Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] MTD: MAPS: bcm963xx-flash.c: explicitly include module.h
References: <1320580651-4860-1-git-send-email-jonas.gorski@gmail.com> <20111107012643.GG30282@windriver.com> <CAOiHx=mmLrfqtp3Nm4WgUT9Vu8pYnVht7tBvwguGMN91bj0Dig@mail.gmail.com>
In-Reply-To: <CAOiHx=mmLrfqtp3Nm4WgUT9Vu8pYnVht7tBvwguGMN91bj0Dig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-07 05:12 AM, Jonas Gorski wrote:
> HI Paul,
> 
> On 7 November 2011 02:26, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>> On 06/11/2011 (Sun 12:57) Jonas Gorski wrote:
>>> This patch is based on next-20111104 and probably should go through Paul's module.h cleanup tree.
>>
>> I can put it in the module.h tree, but for files that are using module.h
>> stuff, they can simply add it via the normal maintainer flow, since
>> files that use modular stuff should include module.h regardless and
>> there are no dependencies on the module.h content for things like this.
> 
> I'm fine with either (though going through the MTD-tree will probably
> warrant a resubmission with a shortened changelog as it doesn't break
> there (yet)).

OK, I'll grab it and put it in the small post-merge queue that I'll be
sending in a couple of hours.

P.

> 
> @David, any preference there? Should I resubmit?
> 
> Regards
> Jonas
