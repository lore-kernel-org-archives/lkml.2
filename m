Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1IFTpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:45:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab1IFTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:45:18 -0400
Date: Tue, 6 Sep 2011 12:45:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: davidel@xmailserver.org, nelhage@ksplice.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RFC] epoll: limit paths
Message-Id: <20110906124507.b62d8158.akpm@linux-foundation.org>
In-Reply-To: <20110906133640.GA6163@redhat.com>
References: <20110902185922.GA8770@redhat.com>
	<20110902144926.69a00396.akpm@linux-foundation.org>
	<20110906133640.GA6163@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 09:36:41 -0400
Jason Baron <jbaron@redhat.com> wrote:

> > I don't think we have any maintained public test code for epoll?  And I
> > trust you have some?  It would be good if you could merge whatever you
> > have into the main kernel.  Then each time we fix bugs or add features,
> > I can harrass people to update the test harness to track the changes.
> > 
> 
> ok. The tests I've used to test this were:
> 
> -pipetest.c: http://www.gelato.unsw.edu.au/archives/linux-ia64/0405/9684.html
> -test I posted in https://lkml.org/lkml/2011/2/25/297
> -test Nelson posted in https://lkml.org/lkml/2011/2/25/297
> -some variations on the above tests
> 
> I can clean these up, and try and propose them for merge...also where would
> they live?

We don't have a formal self-test framework in-kernel.  Probably much
chin-scratching would precede such a thing.  For now I guess you could
follow Steve and use tools/testing/epoll/.

Perhaps you might go as far as to permit one to type "cd tools/testing
; make test" and have it run all the self-tests.  Which will consist of
epoll ;)
