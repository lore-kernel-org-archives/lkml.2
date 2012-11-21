Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2KUBH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:07:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2KUBH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:07:56 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6241843"
Message-ID: <50AC295D.9040101@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 09:07:41 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/11] procfs: Don't cache a pid in the root inode.
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-2-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-2-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 09:07:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 09:07:36,
	Serialize complete at 2012/11/21 09:07:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Now that we have s_fs_info pointing to our pid namespace
> the original reason for the proc root inode having a struct
> pid is gone.
> 
> Caching a pid in the root inode has led to some complicated
> code.  Now that we don't need the struct pid, just remove it.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
