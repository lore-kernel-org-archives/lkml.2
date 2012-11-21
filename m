Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2KUCRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:17:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2KUCRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:17:19 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242638"
Message-ID: <50AC39A7.2010505@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:17:11 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/11] pidns: Don't allow new processes in a dead pid
 namespace.
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-6-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-6-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:17:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:17:02,
	Serialize complete at 2012/11/21 10:17:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Set nr_hashed to -1 just before we schedule the work to cleanup proc.
> Test nr_hashed just before we hash a new pid and if nr_hashed is < 0
> fail.
> 
> This guaranteees that processes never enter a pid namespaces after we
> have cleaned up the state to support processes in a pid namespace.
> 
> Currently sending SIGKILL to all of the process in a pid namespace as
> init exists gives us this guarantee but we need something a little
> stronger to support unsharing and joining a pid namespace.
> 
> Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
