Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1LTXnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:43:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58299 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1LTXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:43:04 -0500
Date: Tue, 20 Dec 2011 15:42:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/5 V3] cgroup: remove redundate get/put of old css_set
 from migrate
Message-ID: <20111220234259.GO10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-2-git-send-email-msb@chromium.org>
 <20111220231823.GK10752@google.com>
 <20111220234131.GV13529@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220234131.GV13529@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 20, 2011 at 03:41:31PM -0800, Mandeep Singh Baines wrote:
> > Either put this as part of patch description or if you don't want it
> > to be part of commit message, put it between --- and diffstat.
> > Unfortunately, no tool understands "-- >8 --".
> > 
> 
> git-am should. From "man git-am":
> 
>        -c, --scissors
>            Remove everything in body before a scissors line (see git-
>            mailinfo(1)).
> 
> From "man git-mailinfo":
> 
>        --scissors
>            Remove everything in body before a scissors line. A line that
>            mainly consists of scissors (either ">8" or "8<") and perforation
>            (dash "-") marks is called a scissors line, and is used to request
>            the reader to cut the message at that line. If such a line appears
>            in the body of the message before the patch, everything before it
>            (including the scissors line itself) is ignored when this option is
>            used.
> 
>            This is useful if you want to begin your message in a discussion
>            thread with comments and suggestions on the message you are
>            responding to, and to conclude it with a patch submission,
>            separating the discussion and the beginning of the proposed commit
>            log message with a scissors line.
> 
>            This can enabled by default with the configuration option
>            mailinfo.scissors.
> 
> But I can stop using scissors if that is what you prefer.

Heh, that's cute.  If git-am is happy, I'm happy too.  Thanks for
letting me know.

Thanks.

-- 
tejun
