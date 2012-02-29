Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2B2Igq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:36:46 -0500
Received: from mx.melware.de ([176.9.26.174]:36148 "EHLO mx.melware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2B2Igp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:36:45 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 03:36:45 EST
Message-ID: <4F4DE175.30002@melware.de>
Date: Wed, 29 Feb 2012 09:27:33 +0100
From: Armin Schindler <armin@melware.de>
Organization: Cytronics & Melware
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Tilman Schmidt <tilman@imap.cc>, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>  <4F4D15E1.3090306@imap.cc> <1330466751.21481.18.camel@joe2Laptop>  <4F4D5E84.8090404@imap.cc> <1330471687.31737.19.camel@joe2Laptop>
In-Reply-To: <1330471687.31737.19.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:28 AM, Joe Perches wrote:
> On Wed, 2012-02-29 at 00:08 +0100, Tilman Schmidt wrote:
>> Am 28.02.2012 23:05, schrieb Joe Perches:
>>> On Tue, 2012-02-28 at 18:58 +0100, Tilman Schmidt wrote:
>>>> Please remember to CC the maintainers of the affected code this time.
>>> Karsten Keil is the nominal maintainer for
>>> all of drivers/isdn.
>> Look again.
>
> What I wrote is correct.
>
> I am aware there are 2 other ISDN sections
> and maintainers listed in MAINTAINERS.
>
> One of those, Armin Schindler, (cc'd) hasn't
> signed a single commit in git history.

True, my last work here was a long time ago.
I used to maintain the eicon driver, but this driver
is not just old, it is simply outdated for years and
I doubt someone will ever use it in newer kernels.
It just creates work here.

Some time ago I asked (I don't remember who) why
don't we remove that old driver from the kernel.
It wasn't done because there is no follow up for the
kernel. The new drivers out there are maintained,
but will never be part of the kernel (coding style, etc.).
I guess the idea was not to remove a driver from the kernel
when there is no alternative (in kernel).
Maybe I should bring this up again and ask for a removal of the
current eicon driver in kernel...

regards,
Armin


