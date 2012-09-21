Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2IUAZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:25:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2IUAZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:25:15 -0400
Date: Thu, 20 Sep 2012 17:25:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Feng Hong <hongfeng@marvell.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] poweroff: fix bug in orderly_poweroff
Message-Id: <20120920172513.a23d061c.akpm@linux-foundation.org>
In-Reply-To: <E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
References: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
	<20120920170647.GA26278@mail.hallyn.com>
	<E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 17:16:35 -0700
Feng Hong <hongfeng@marvell.com> wrote:

> I am just a graduate and it's my first time to send a patch to
> opensource, so thank you very much for reminding me the "changelog
> affairs", it seems this patch has been added to -mm tree as attached
> mail, and I have no chance to change the comments, right ?  Then I must
> remember this and be careful next time.  Thanks again for reminding me!

It depends.  If the person who committed the patch was using a git tree
then it can be difficult for them to alter a changelog.

But the -mm tree is not mastered in git (for this and other reasons),
and I alter changelogs all the time.  So please feel free to send
replacement text and I shall copy-n-paste that text straight into the patch.

