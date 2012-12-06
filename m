Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423923Ab2LFPm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:42:29 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40584 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423892Ab2LFPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:42:27 -0500
Date: Thu, 6 Dec 2012 15:42:20 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Bin Wang <wbin00@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH RFC -next] Fix the trailing blank space issue
Message-ID: <20121206154219.GA24788@gmail.com>
References: <1354784936-5647-1-git-send-email-wbin00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354784936-5647-1-git-send-email-wbin00@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 05:08:56PM +0800, Bin Wang wrote:
> This patch removes the trailing white space in fs/sysfs/mount.c.
> 
> Signed-off-by: Bin Wang <wbin00@gmail.com>
> ---
>  fs/sysfs/mount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Hi Greg,

I am not sure it is really necessary to remove all the trailing blank spaces
in the project. I have done a try by this shell command
$ find . -iname '*.[ch]' | xargs sed 's/\s\+$//g' -i
and find there are 2812 files/31712 lines with this issue. 

If necessary, I think it's better to run this shell code by yourself in the
whole linux-next tree and commit it. Nevertheless, the patch file of my try is
available from gist: https://gist.github.com/4225286

Even the diff summary is very large, hence I attach a simple version diff
result and commit information here. 

- cong

---
>From 30ed9bb0e6f7c8866447d27c86f466c44749116e Mon Sep 17 00:00:00 2001
From: Cong Ding <dinggnu@gmail.com>
Date: Thu, 6 Dec 2012 15:58:15 +0100
Subject: [PATCH RFC -next] remove all the trailing blank space

clean all the trailing blank space by using shell command
$ find . -iname '*.[ch]' | xargs sed 's/\s\+$//g' -i

I have manually checked a random set of all the changes, and find no error.
I also compiled the whole system and tested many times by randconfig.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 2812 files changed, 31712 insertions(+), 31712 deletions(-)
