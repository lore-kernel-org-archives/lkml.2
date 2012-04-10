Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab2DJCJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:09:20 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:34656 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112Ab2DJCJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:09:18 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rientjes@google.com
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 09 Apr 2012 22:13:13 -0400
Message-ID: <web-723121979@zbackend1.aha.ru>
In-Reply-To: <4F83923E.6010802@redhat.com>
References: <web-723115389@zbackend1.aha.ru>
 <4F83923E.6010802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel :
To avoid misunderstandings, that improvement is WITH / 
INCLUDING the patch suggested by D.R and L.T., namely: 
 put + free_task(task); after line 78 in subroutine 
lowmemorykiller.c   .  At least phenomenologically, it 
looks that it resolved the problem
I dont understanding so much about programming and about 
the problem (and "android" is neither running on my own 
computer nor on my coffee-machine, but I enable everything 
just because I don't know what hardware have the people 
which use my distro and compiled kernels) so that I don't 
understand all details of the discusion,  but if people 
come to an agreement what I could test further, one can 
mail it me and explain it me slowly, then I test it out.
wl

==========

On Mon, 09 Apr 2012 21:51:58 -0400
  Rik van Riel <riel@redhat.com> wrote:
> On 04/09/2012 09:52 PM, werner wrote:
>> At least until now, and also tested hard by starting and 
>>stopping
>> several memory-consuming operations, I'm happy to can 
>>inform that the
>> computer didnt yet crash again, and that also 
>>slownessnesses what I
>> observed under 3.3 (but without crashs) don't occur
> 
> That could be due to a few VM patches which I wrote, 
>that
> went in through -mm.
> 
> I am very interested in whether people do find a way to
> break the VM with those patches, in ways that used to 
>work
> before.
> 
> If you find any, please let me know so I can fix them
> before the 3.4 kernel comes out.
> 
> If everything you try works better than before, I'm not
> going to complain about good news :)
> 
> -- 
> All rights reversed
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
