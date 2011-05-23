Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1EWI4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:56:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63844 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1EWI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=RHvj24wm8TLbiqi/7pIbgKB/7r/Z8hmqiu4yiKhKzUCY/fI/vkYPuYD4rTQKQQw81r
         rpO3vSkgU5vWQCzMLnebsS03TUf7aJ8EV8ZSbeo0V3EElHplQQ9BMHJQeX87/Ll9XX0V
         Wa+lGbTd91tSjmszzTCk6dHWG3GQPnCEMdfsU=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "nbd\@openwrt.org" <nbd@openwrt.org>, "neilb\@suse.de" <neilb@suse.de>,
        "hramrach\@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp\@gmail.com" <jordipujolp@gmail.com>
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
	<D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
	<87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu>
	<7dcd9c4e62864bc6aae66f5a4e3f3752@HUBCAS1.cs.stonybrook.edu>
	<2983EA36-BB3B-4AE3-9CAA-5A3C2D884DCF@fsl.cs.sunysb.edu>
Date: Mon, 23 May 2011 10:57:02 +0200
In-Reply-To: <2983EA36-BB3B-4AE3-9CAA-5A3C2D884DCF@fsl.cs.sunysb.edu> (Erez
	Zadok's message of "Sat, 21 May 2011 00:26:47 -0400")
Message-ID: <87aaed23s1.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:

> Done: reverted my ovl patches and applied yours.  And indeed, the NULL
> oopses don't show up after 10 minutes of running.  Just to be sure, I
> ran overlayfs on top of ext2, ext3, xfs, reiserfs, and tmps — no
> oopses.  And I wasn't able to reproduce the WARN_ON in ovl_permission.

Great, thanks for testing.  Pushed to .v9 branch.

> Are you interested in testing overlayfs on top of NFS at this time?

No, not as an upper layer.  NFS as a lower layer should work fine.

Thanks,
Miklos
