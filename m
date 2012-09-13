Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab2IMW0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:26:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab2IMW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:26:00 -0400
Date: Thu, 13 Sep 2012 15:25:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Cong Wang <amwang@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jiri Moskovcak <jmoskovc@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] coredump: add support for %d=__get_dumpable() in
 core name
Message-Id: <20120913152559.d0a9ade0.akpm@linux-foundation.org>
In-Reply-To: <20120913172817.GA11337@redhat.com>
References: <20120913172817.GA11337@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 19:28:17 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> https://bugzilla.redhat.com/show_bug.cgi?id=787135

Needs a RH bugzilla account, so no Reported-by: for you!

> Some coredump handlers want to create a core file in a way compatible
> with standard behavior. Standard behavior with fs.suid_dumpable = 2
> is to create core file with uid=gid=0. However, there was no way for
> coredump handler to know that the process being dumped was suid'ed.
> 
> This patch adds the new %d specifier for format_corename() which
> simply reports __get_dumpable(mm->flags), this is compatible with
> /proc/sys/fs/suid_dumpable we already have.

Please prepare an update to Documentation/sysctl/kernel.txt:core_pattern?
