Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1HWA7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:59:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1HWA7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:59:49 -0400
Message-ID: <4E52FBA8.8020508@cn.fujitsu.com>
Date: Tue, 23 Aug 2011 09:00:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Wanlong Gao <wanlong.gao@gmail.com>
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs:make close_ctree() return void
References: <1314026291-8873-1-git-send-email-wanlong.gao@gmail.com>
In-Reply-To: <1314026291-8873-1-git-send-email-wanlong.gao@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 08:58:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 08:58:48,
	Serialize complete at 2011-08-23 08:58:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanlong Gao wrote:
> From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> Make close_ctree() return void since it always return 0, and fix
> the return value of btrfs_put_super() to consistent with VFS.
> 

I don't quite like this patch. We do have some failure cases in
close_ctree(), but this doesn't fix that while have the FIXME
tag removed.

--
Li Zefan
