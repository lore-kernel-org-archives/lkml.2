Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1LEGxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:53:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1LEGxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:53:05 -0500
Message-ID: <4EDC6A42.1090806@redhat.com>
Date: Mon, 05 Dec 2011 14:52:50 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please add my tree to linux-next
References: <4ED8529E.5070608@redhat.com>	<20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>	<4EDC594D.5040008@redhat.com> <20111205171207.3b3bc1ad6d99ad7d7c9c0792@canb.auug.org.au>
In-Reply-To: <20111205171207.3b3bc1ad6d99ad7d7c9c0792@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月05日 14:12, Stephen Rothwell 写道:
> Hi,
> On Mon, 05 Dec 2011 13:40:29 +0800 Cong Wang<amwang@redhat.com>  wrote:
>>
>>>        * submitted under GPL v2 (or later) and include the Contributor's
>>> 	Signed-off-by,
>>
>> When I sent the patches out, they all have my Signed-off-by, but not in the
>> commit logs in my tree. Is this a problem?
>
> Yes, you must have a signed-off-by line for each person who handles the
> patches (in this case just you, since you are also the author).
> Linus (in theory) would not merge your tree if you asked him to if it
> lacked signed-off-by lines (and I will have to drop it if they are not
> added - this will mean rebasing your tree, of course).
>

Ok, I will re-commit those patches with my S-o-b and rebase my tree.

Thanks!
