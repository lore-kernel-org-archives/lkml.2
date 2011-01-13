Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1AMTBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:01:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933155Ab1AMTBG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:01:06 -0500
MIME-Version: 1.0
In-Reply-To: <4D2F03F2.4000707@fusionio.com>
References: <4D2F03F2.4000707@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 11:00:43 -0800
Message-ID: <AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
To: Jens Axboe <jaxboe@fusionio.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 5:53 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Pekka Enberg (1):
>      floppy: replace NO_GEOM macro with a function

Hmm. When I see work on floppy.c, I end up wondering what happened to
the work by Stephen to use a single threaded workqueue?

That was reported to fix a KVM oops at some point to to avoiding the
whole race between interrupts/workqueues, but it seems to have dropped
off everybody's radar. I don't think anybody ever tested it on real
hardware, but I'm still wondering..

Anybody?

                    Linus
