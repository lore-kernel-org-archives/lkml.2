Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2KSJMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:12:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2KSJMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:12:06 -0500
X-IronPort-AV: E=Sophos;i="4.83,278,1352044800"; 
   d="scan'208";a="6229943"
Message-ID: <50A9F7DE.60807@cn.fujitsu.com>
Date: Mon, 19 Nov 2012 17:11:58 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/11] pidns: Add setns support
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-9-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-9-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 17:11:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 17:11:52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月17日 00:35, Eric W. Biederman 写道:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Pid namespaces are designed to be inescapable so verify that the
>   passed in pid namespace is a child of the currently active
>   pid namespace or the currently active pid namespace itself.
> 
>   Allowing the currently active pid namespace is important so
>   the effects of an earlier setns can be cancelled.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Hi Eric

I noticed that,after we call setns to change task's pidns to container A's pidns.
we can't see this task in container A's proc filesystem.

Is this what we expected?

Thanks
Gao
