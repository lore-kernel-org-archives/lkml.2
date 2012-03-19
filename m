Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162282Ab2CSRB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:01:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45647 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab2CSRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:01:28 -0400
Date: Mon, 19 Mar 2012 10:01:22 -0700
From: Tejun Heo <tj@kernel.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
Message-ID: <20120319170122.GG11069@google.com>
References: <4F6600FA.7050005@gmail.com>
 <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F661E89.5050000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F661E89.5050000@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 10:42:33AM -0700, Justin P. Mattock wrote:
> >Known problem.  The following pending patchset should fix the problem.
> >
> >   http://thread.gmane.org/gmane.linux.kernel/1263989
> >
> >Jens?
> >
> >Thakns.
> >
> 
> cool thanks for the info..
> I went and applied your patches(all 5) and there is fuzz, and some
> errors with linux-next.
> seems the suspicious message is still there, but the system boots up
> just fine with the patches in.
>  maybe manually applying them by hand is what I need to do for -next
> so I dont miss anything important with the patch that takes care of
> the suspicious message.

Hmm... weird.  I just double check and the patch series makes the
warning go away.  Can you please try the following git branch instead?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stats

Thanks.

-- 
tejun
