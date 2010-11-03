Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0KCN0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0KCN0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:26:20 -0400
Date: Wed, 3 Nov 2010 09:26:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Nauman Rafique <nauman@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
Message-ID: <20101103132607.GA2920@redhat.com>
References: <20101102222030.GI7198@redhat.com>
 <AANLkTi=U4MY1jEE60arAPz0iKbVcV__3WfHjU3eikaeh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=U4MY1jEE60arAPz0iKbVcV__3WfHjU3eikaeh@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:11:24PM -0700, Chad Talbott wrote:
> On Tue, Nov 2, 2010 at 3:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Allow hierarchical cgroup creation for blkio controller
> 
> Vivek,
> 
> This patch looks fine, and we use similar code.  I'd be even more
> interested in directing effort at Gui's patchset that fully implements
> hierarchy.  If there are specific details that are blocking adoption
> of that code, let's address them.

Hi Chad,

My primary concern was re-organizing the code in such a way so that we
treat queues and groups at the same level. I think Gui is now addressing
those concerns.

I have detailed my concerns in this thread. (You are CCed though in the
thread).

http://lkml.org/lkml/2010/8/30/30

Thanks
Vivek
