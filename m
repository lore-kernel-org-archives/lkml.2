Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2DQXA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:00:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2DQXA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:00:57 -0400
Date: Tue, 17 Apr 2012 16:00:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/8] ipc/mqueue: switch back to using non-max values on
 create
Message-Id: <20120417160055.f8e35101.akpm@linux-foundation.org>
In-Reply-To: <4F8DEF79.409@gmail.com>
References: <cover.1334676645.git.dledford@redhat.com>
	<a9cfc656e665735e11606d452a536a9a9e6ebdde.1334676645.git.dledford@redhat.com>
	<20120417151729.e255188c.akpm@linux-foundation.org>
	<4F8DEF79.409@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 18:32:25 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> > Here the "future patch" is "mqueue: separate mqueue default value from
> > maximum value v2" in this series, yes?
> >
> > So people who have applications which are broken by this patch will
> > need to manually set /proc/sys/fs/mqueue/msg_default and/or
> > /proc/sys/fs/mqueue/msgsize_default to get those apps working again?
> >
> 
> Yes, it works.
> 

OK, I updated the changelog for this patch to reflect that.

I worry a bit that some people who we don't know about will hit this
problem and will have to spend a lot of time working out why it broke. 
Is there some way in which we can make it easier for them?  A little
printk_once() in a suitable place?


