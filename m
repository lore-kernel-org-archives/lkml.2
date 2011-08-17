Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1HQCkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:40:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab1HQCkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:40:31 -0400
Message-ID: <4E4B2A33.6060909@cn.fujitsu.com>
Date: Wed, 17 Aug 2011 10:40:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/8] cgroups: New cancel_attach_task subsystem callback
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1311956010-32076-5-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:39:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:39:14,
	Serialize complete at 2011-08-17 10:39:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> To cancel a process attachment on a subsystem, we only call the
> cancel_attach() callback once on the leader but we have no
> way to cancel the attachment individually for each member of
> the process group.
> 
> This is going to be needed for the max number of tasks susbystem
> that is coming.
> 
> To prepare for this integration, call a new cancel_attach_task()
> callback on each task of the group until we reach the member that
> failed to attach.
> 

Document this new callback in Documentation/cgroups/cgroups.txt

--
Li Zefan
