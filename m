Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1FJMNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:13:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:51458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1FJMNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:13:33 -0400
Message-ID: <4DF20A68.2090307@suse.cz>
Date: Fri, 10 Jun 2011 14:13:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild fixes for 3.0
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com> <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com> <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com> <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
In-Reply-To: <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.6.2011 05:57, Linus Torvalds wrote:
> On Thu, Jun 9, 2011 at 8:45 PM, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>>
>> For the record, this should have been fixed by Michal in:
>
> You're missing the problem: we can't assume that people have updated user land.
>
> Furthermore, the very pull request I'm responding to actually tries to
> handle this, see commit bfe5424a8b31 ("kbuild: Hack for depmod not
> handling X.Y versions"), but it's just not working for me.

It handles what can be handled inside the kernel build, i.e. the depmod 
called from the Makefile during modules_install.


> And it's not working, because it only handles the "modules_install"
> case, not the case where the system install scripts do their own
> depmod.

Yes, tools creating an initrd would need a similar workaround, that's a 
pity :-(.

Michal
