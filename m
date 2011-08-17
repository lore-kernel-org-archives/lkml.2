Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1HQHvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:51:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60261 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1HQHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:51:14 -0400
Date: Wed, 17 Aug 2011 09:51:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/3] kill PF_STARTING
Message-ID: <20110817075110.GK4254@htj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
 <20110729192358.GB31717@mtj.dyndns.org>
 <20110812175550.GA7484@redhat.com>
 <20110812175701.GE7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175701.GE7484@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 07:57:01PM +0200, Oleg Nesterov wrote:
> Previously it was (ab)used by utrace. Then it was wrongly used by
> the scheduler code.
> 
> Currently it is not used, kill it before it finds the new erroneous
> user.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks. :)

-- 
tejun
