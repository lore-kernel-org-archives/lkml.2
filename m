Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2ITOer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:34:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:53050 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab2ITOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:34:45 -0400
Date: Thu, 20 Sep 2012 23:34:34 +0900 (JST)
Message-Id: <20120920.233434.135419220.konishi.ryusuke@lab.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 18/25] userns: Convert nillfs2 to use kuid/kgid where
 appropriate
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1348141326-23355-18-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
	<1348141326-23355-1-git-send-email-ebiederm@xmission.com>
	<1348141326-23355-18-git-send-email-ebiederm@xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Thu, 20 Sep 2012 23:34:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 04:41:59 -0700, "Eric W. Biederman" wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/nilfs2/inode.c |    8 ++++----
>  init/Kconfig      |    1 -
>  2 files changed, 4 insertions(+), 5 deletions(-)

Looks good to me, thanks.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Ryusuke Konishi
