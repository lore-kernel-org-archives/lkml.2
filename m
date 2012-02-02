Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab2BBT4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:56:15 -0500
Received: from mx2.compro.net ([12.186.155.4]:47270 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2BBT4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:56:14 -0500
X-IronPort-AV: E=Sophos;i="4.73,347,1325480400"; 
   d="scan'208";a="7582941"
Message-ID: <4F2AEABF.2020106@compro.net>
Date: Thu, 02 Feb 2012 14:57:51 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: git question
References: <4F2AE6E9.5090402@compro.net> <4F2AE8D2.2090000@fastmail.fm>
In-Reply-To: <4F2AE8D2.2090000@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:49 PM, Jack Stone wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 02/02/12 19:41, Mark Hounschell wrote:
>> It's been a while but this used to work.
>>
>> # git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
>>
>>
> Cloning into linux-2.6-allstable...
>> fatal: The remote end hung up unexpectedly
>>
>> Google showed nothing helpful? Where do I go. I need to bisect
>> from 2.6.38 to 2.6.39
>>
>
> That repo has been deleted. The full list is available at:
>
> git.kernel.org
>
> If you want to bisect 2.6.38 ->  2.6.39 then I sugest you try :
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>
> Which is Linus' official repo. If you want to bisect from 2.6.38.x ->
> something else then you will have to try the stable repo, I think the
> following will help:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>
> The only thing to be careful of is that 2.6.39.x is not a direct
> decendant of 2.6.38.x, but it is a direct decentant of 2.6.38: the
> stable trees have patches added in parallel.
>
> Hope this helps,

Yes it does. Thank you very much.

Mark

