Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1HQHu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:50:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60261 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1HQHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:50:58 -0400
Date: Wed, 17 Aug 2011 09:50:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 3/3] coredump_wait: don't call complete_vfork_done()
Message-ID: <20110817075052.GJ4254@htj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
 <20110729192358.GB31717@mtj.dyndns.org>
 <20110812175550.GA7484@redhat.com>
 <20110812175646.GD7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175646.GD7484@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the delay.

On Fri, Aug 12, 2011 at 07:56:46PM +0200, Oleg Nesterov wrote:
> Now that CLONE_VFORK is killable, coredump_wait() no longer needs
> complete_vfork_done(). zap_threads() should find and kill all tasks
> with the same ->mm, this includes our parent if ->vfork_done is set.
> 
> mm_release() becomes the only caller, unexport complete_vfork_done().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Yeap, looks pretty good to me.  For all three patches,

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
