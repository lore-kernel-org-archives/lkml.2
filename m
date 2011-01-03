Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1ACOWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:22:47 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:42411 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754784Ab1ACOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:22:45 -0500
Message-ID: <4D21DBB0.1080007@example.com>
Date: Mon, 03 Jan 2011 15:22:40 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT question - am I doing it correctly?
References: <4D1B6066.9000701@example.com> <20110103134807.GA3911@tiehlicka.suse.cz>
In-Reply-To: <20110103134807.GA3911@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15834656291108974861
X-Ovh-Remote: 178.42.67.78 (afmp78.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.01.2011 14:48, Michal Hocko wrote:
> On Wed 29-12-10 17:23:02, Piotr Hosowicz wrote:
>> Hello,
>
> Hi,
>
>>
>> Everytime I git pull tyhe Linus' sources but before I build I apply
>> Peter Zijlstra's fixes, Takashi Iwai's sources and Dave Miller's
>> sources. The sequence is:
>>
>> # the Linus' sources
>> git pull
>>
>> # external sources
>> git remote add some_name git://some_URL.git
>>
>> # update
>> git remote update
>>
>> Then configure and I build. I noticed that especially Peter's
>> git-update very quickly, not as long as they did before.
>>
>> Is my procedure correct? I am new to GIT.
>
> What do you want to achieve? You want to build the tree that you have
> added as a remote? If yes then you need to checkout a branch from that
> remote
>
> git checkout -b your_branch_name some_name/branch_you_want
>
> then you will have a new your_branch_name which points to the tip of the
> remote's branch and you can configure and make the tree.
>
> Please note that 'git remote add&&  git remote update' will just add
> commits from that remote tree and it doesn't affect your local copy
> anyhow.

Well, this is exactly answer to my question, but it is straghtly 
contrary to what Peter Zijlstra wrote me. Well, I'll build the kernel 
now your way.

> If you are new to GIT I would strongly encourage you to read through the
> following ebook: http://progit.org/book/

I'am new. Thanks for the URL.

Regards,

Piotr Hosowicz

-- 
- Za moich czasów to w sklepach by³ tylko ocet i denaturat!
- Tato, przestañ, ¿e w ca³ym Tesco by³ tylko ocet i denaturat!
NP: Peter Green Splinter Group - I Can't Help Myself
NB: 2.6.37-rc8-git3
