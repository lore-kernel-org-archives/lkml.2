Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab1LGRvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:51:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33952 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1LGRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:51:31 -0500
Date: Wed, 7 Dec 2011 17:51:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207175127.GE2203@ZenIV.linux.org.uk>
References: <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
 <20111207034238.GX2203@ZenIV.linux.org.uk>
 <201112070501.pB751LoP064331@www262.sakura.ne.jp>
 <20111207051908.GA2203@ZenIV.linux.org.uk>
 <201112070544.pB75iX12072157@www262.sakura.ne.jp>
 <20111207065437.GB2203@ZenIV.linux.org.uk>
 <201112070859.pB78xn7x007845@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112070859.pB78xn7x007845@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:59:49PM +0900, Tetsuo Handa wrote:

> [PATCH] TOMOYO: Fix pathname handling of disconnected paths.
> 
> Current tomoyo_realpath_from_path() implementation returns strange pathname
> when calculating pathname of a file which belongs to lazy unmounted tree.
> Use local pathname rather than strange absolute pathname in that case.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

seeing that Linus has already pulled mine, I guess the best I can do is
this:

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
