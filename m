Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0LKVeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 16:34:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33498 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0LKVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 16:34:09 -0500
Date: Sat, 11 Dec 2010 13:33:09 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 07/30] ocfs2: don't use flush_scheduled_work()
Message-ID: <20101211213308.GA8555@mail.oracle.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
	Mark Fasheh <mfasheh@suse.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292086307-19211-8-git-send-email-tj@kernel.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 05:51:24PM +0100, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> 
> * cancel_delayed_work() + flush_schedule_work() ->
>   cancel_delayed_work_sync().
> 
> * flush qs->qs_work directly on exit instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <joel.becker@oracle.com>

Acked-by: Joel Becker <joel.becker@oracle.com>

-- 

#!/bin/perl -sp0777i<X+d*lMLa^*lN%0]dsXx++lMlN/dsM0<j]dsj
$/=unpack('H*',$_);$_=`echo 16dio\U$k"SK$/SM$n\EsN0p[lN*1
lK[d2%Sa2/d0$^Ixp"|dc`;s/\W//g;$_=pack('H*',/((..)*)$/)

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
