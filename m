Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2KUB0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:26:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab2KUB0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:26:11 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242133"
Message-ID: <50AC2DAB.8010609@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 09:26:03 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/11] pidns: Capture the user namespace and filter ns_last_pid
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-3-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-3-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 09:25:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 09:25:55,
	Serialize complete at 2012/11/21 09:25:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Capture the the user namespace that creates the pid namespace
> - Use that user namespace to test if it is ok to write to
>   /proc/sys/kernel/ns_last_pid.
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
