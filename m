Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2KUC5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:57:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2KUC5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:57:02 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242976"
Message-ID: <50AC42F6.3090403@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:56:54 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/11] pidns: Consolidate initialzation of special init
 task state
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-10-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-10-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:56:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:56:45,
	Serialize complete at 2012/11/21 10:56:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Instead of setting child_reaper and SIGNAL_UNKILLABLE one way
> for the system init process, and another way for pid namespace
> init processes test pid->nr == 1 and use the same code for both.
> 
> For the global init this results in SIGNAL_UNKILLABLE being set
> much earlier in the initialization process.
> 
> This is a small cleanup and it paves the way for allowing unshare and
> enter of the pid namespace as that path like our global init also will
> not set CLONE_NEWPID.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
