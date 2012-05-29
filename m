Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2E2V7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 17:59:18 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:56472 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752511Ab2E2V7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 17:59:17 -0400
Message-ID: <4FC546B1.8050508@fold.natur.cuni.cz>
Date: Tue, 29 May 2012 23:59:13 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120517 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "hughd@google.com" <hughd@google.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: 3.4-rc7: BUG: Bad rss-counter state mm:ffff88040b56f800 idx:1
 val:-59
References: <4FBC1618.5010408@fold.natur.cuni.cz> <20120522162835.c193c8e0.akpm@linux-foundation.org> <20120522162946.2afcdb50.akpm@linux-foundation.org> <20120523172146.GA27598@redhat.com> <4FC52F17.20709@openvz.org> <20120529132658.14ab9ba3.akpm@linux-foundation.org>
In-Reply-To: <20120529132658.14ab9ba3.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 30 May 2012 00:18:31 +0400
> Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> 
>> Oleg Nesterov wrote:
>>> On 05/22, Andrew Morton wrote:
>>>>
>>>> Also, I have a note here that Oleg was unhappy with the patch.  Oleg
>>>> happiness is important.  Has he cheered up yet?
>>>
>>> Well, yes, I do not really like this patch ;) Because I think there is
>>> a more simple/straightforward fix, see below. In my opinion it also
>>> makes the original code simpler.
>>>
>>> But. Obviously this is subjective, I can't prove my patch is "better",
>>> and I didn't try to test it.
>>>
>>> So I won't argue with Konstantin who dislikes my patch, although I
>>> would like to know the reason.
>>
>> I don't remember why I dislike your patch.
>> For now I can only say ACK )
> 
> We'll need a changelogged signed-off patch, please Oleg.  And some evidence
> that it was tested would be nice ;)

I will reboot in few hours, finally after few days ... I am running this first
patch. I will try to test the second/alternative patch more quickly. Sorry for
the delay.

