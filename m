Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1GTQkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:40:47 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50915 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1GTQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:40:45 -0400
Date: Wed, 20 Jul 2011 18:40:34 +0200
From: Tejun Heo <tj@kernel.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH RESEND] scsi: don't use execute_in_process_context()
Message-ID: <20110720164034.GD9924@mtj.dyndns.org>
References: <20110430145602.GL29280@htj.dyndns.org>
 <20110615102022.GV8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615102022.GV8141@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:20:22PM +0200, Tejun Heo wrote:
> On Sat, Apr 30, 2011 at 04:56:02PM +0200, Tejun Heo wrote:
> > James, can we please get rid of execute_in_process_context()?  It
> > didn't help the recent crash case which was a separate issue but
> > didn't break anything either, and this is one of the last several
> > users of flush_scheduled_work() that I really want to remove.
> 
> (resending due to devlivery failure on suse address)
> 
> James, ping.

Ping, ping ping.

-- 
tejun
