Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1AGQHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:07:42 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:56767 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753987Ab1AGQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:07:41 -0500
Message-ID: <4D273A48.4020302@example.com>
Date: Fri, 07 Jan 2011 17:07:36 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT again
References: <4D272D7C.4070900@example.com> <20110107154302.GF1891@tiehlicka.suse.cz>
In-Reply-To: <20110107154302.GF1891@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4199888127832781069
X-Ovh-Remote: 83.24.110.28 (doc28.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2011 16:43, Michal Hocko wrote:
> On Fri 07-01-11 16:13:00, Piotr Hosowicz wrote:
>> Hello,
>>
>> Sorry for bothering again. I think I fimanaged to build the kernel
>> as I wanted to. Lets simplify the problem. There is Linus tree and a
>> separate tree, which was announed here as:
>>
>> git://git.kernel.org/some.git for-linus
>>
>> The objective is to build the kernel with Linus sources with
>> some.git changes incorporatwed in it. I think I managed to achieve
>> the objective doing:
>>
>> # let me remind myself ;-)
>> git clone<Linus URL here>
>> git remote add some git://git.kernel.org/some.git
>> git pull some for-linus
>
> Yes, this will merge some/for-linus branch into the current branch which
> is master (from the above sequence of commands).

Thanks.

>> I've done it this way and I am convinced I've achieved the
>> objective. But not sure.
>
> git pull is essentially the same thing as git fetch and git merge. The
> first command fetches all commits from the remote and the second one
> will merge your current tree with the given branch (it doesn't care much
> about the fact those commits come from a remote repository as those
> objects are available locally after fetch)

Thanks.

>> For sure the last command modified the
>> source, what is what I wanted, I had to finally correct ot by hand
>> and do git commit -a.
>
> This is because you could end up with some conflicts after merge.
> Anyway, git commit -a is not the best way to do this in general. I would
> encourage you to use git status to get an overview of what has changed
> (what is the conflict etc...) and selectively git add only those changes
> that are relevant and then git commit after you are done.

I thought so. Thanks.

> Btw. the way you did this is not very much optimal. You have merged
> something into your _master_ branch which means that when-ever you want
> to pull again from linus you will have to merge again. In general I tend
> to keep the _master_ branch without any modifications and do all my
> changes (merges with other external sources etc.) in dedicated branches
> so that I can keep following linus master without any modifications.

That is a future stage to some. Now I am happy and proud I have what I 
wanted.

Thanks, regards,

Piotr Hosowicz

-- 
<Nub> Mo¿e mi kto¶ wyt³umaczyæ, jak dziel± sie komórki?
<Tolek> o
<Tolek> O
<Tolek> 8
<Tolek> o o
NP: Peter Green Splinter Group - Burglar
NB: 2.6.37-20110107-1437-pztidm+
