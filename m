Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2KMRzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:55:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2KMRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:55:09 -0500
Date: Tue, 13 Nov 2012 18:55:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113175538.GA21872@redhat.com>
References: <20121113145050.GA13691@redhat.com> <20121113155313.GU6511@moon> <20121113162056.GK7808@moon> <20121113164951.GA18665@redhat.com> <20121113170159.GW6511@moon> <20121113171422.GM7808@moon> <20121113174706.GA20626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113174706.GA20626@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, sorry for noise...

On 11/13, Oleg Nesterov wrote:
>
> On 11/13, Cyrill Gorcunov wrote:
> >
> > On Tue, Nov 13, 2012 at 09:01:59PM +0400, Cyrill Gorcunov wrote:
> > >
> > The sigmask is read in lockless manner for a sake of
> > code simplicity, thus if precise data needed here
> > the tasks which refer to the signalfd should be
> > stopped before read.
>
> Yes, I think this is fine, and this patch should replace
> fs-epoll-add-procfs-fdinfo-helper.patch in -mm.

I meant fdinfo-show-sigmask-for-signalfd-fd.patch

And the subject was wrong from the very beginning, sorry for confusion.

Oleg.

