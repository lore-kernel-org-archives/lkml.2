Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985Ab2JYNeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:34:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945936Ab2JYNeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:34:19 -0400
Message-ID: <50893FCF.5030800@suse.cz>
Date: Thu, 25 Oct 2012 15:34:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
Subject: Re: [PATCH v2] menuconfig: Replace CIRCLEQ by list_head-style lists.
References: <1350754935-20014-1-git-send-email-benjamin.poirier@gmail.com> <1350811673-26081-1-git-send-email-benjamin.poirier@gmail.com> <201210222138.25805.yann.morin.1998@free.fr>
In-Reply-To: <201210222138.25805.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.10.2012 21:38, Yann E. MORIN wrote:
> Benjamin, Michal, All,
> 
> On Sunday 21 October 2012 Benjamin Poirier wrote:
>> From: Benjamin Poirier <bpoirier@suse.de>
>>
>> sys/queue.h and CIRCLEQ in particular have proven to cause portability
>> problems (reported on Debian Sarge, Cygwin and FreeBSD)
> 
> Benjamin,
> 
> Thank you for working on this! :-)

Yeah, thanks!


>>
>> Changes v1-v2:
>> * integrate the patch/suggestion from Yann to fix problems related to the
>>   usage of list.h with xconfig/c++
>> 	* "new" keyword
>> 	* offsetof redefinition
>> * silly #endif placement mistake
> 
> Michal,
> 
> Any more comments on this patch?
> 
> If not, then I would suggest to push it for inclusion before 3.7 is released
> (I believe it can go in, as it is a bugfix, not a new feature).

I pushed it to kbuild.git#rc-fixes now and will send it to Linus for 3.7
inclusion later.

Michal
