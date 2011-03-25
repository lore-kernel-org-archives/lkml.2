Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1CYRK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:10:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58299 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1CYRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:10:56 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Two fixups for the block IO merge
In-reply-to: <4D8CBDAB.2010507@fusionio.com>
References: <4D8CBDAB.2010507@fusionio.com>
Date: Fri, 25 Mar 2011 13:09:52 -0400
Message-Id: <1301072954-sup-4222@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D8CCC97.01A0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jens Axboe's message of 2011-03-25 12:07:07 -0400:
> Hi Linus,
> 
> An embarassing bug made the block IO merge a bit less enjoyable for some
> people than it should have.
> 
> - The oops problem (with CFQ), or potential corruption (with noop) due
>   to a bad insertion type for some requests.
> 
> - A warning spew on virt_io using blk_stop_queue() inside it's callback.
> 
> Please pull these two fixes, so hopefully we can put this behind us.
> Thanks a lot to the people involved with fixing the first issue.
> 
>   git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> Jens Axboe (2):
>       block: fix bug with inserting flush requests as sort/merge
>       block: fix issue with calling blk_stop_queue() from the request_fn handler

A quick stress test on this is going well on my box.  Before this pull
it would crash within 5 minutes.

-chris
