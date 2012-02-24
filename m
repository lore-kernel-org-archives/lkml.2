Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2BXOkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:40:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab2BXOkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:40:36 -0500
Date: Fri, 24 Feb 2012 09:40:32 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120224144032.GA13903@zod.bos.redhat.com>
References: <20120222011652.GE23186@zod.bos.redhat.com>
 <20120222013252.GZ2375@linux.vnet.ibm.com>
 <20120222014242.GF23186@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222014242.GF23186@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 08:42:43PM -0500, Josh Boyer wrote:
> > And patch #47 in that series has been obsoleted by another series
> > from Steven Rostedt:
> > 
> > 	https://lkml.org/lkml/2012/2/7/231
> 
> Ok.
> 
> > Hopefully these fix both splats and slowness.
> 
> So again, I'm slightly confused on how RCU patches flow.  Eric
> originally reported the bug for which you created the patch I applied
> against 3.3.  The giant patch series above seems queued for 3.4.
> 
> I don't see stable CC'd on 45-47, nor any of Steven's patches.  I doubt
> I'd want to go applying the 47-patch series on 3.3 at the moment, and
> given you have these marked for 3.4 I don't think you do either.
> However, is there some kind of fix for the original bug report against
> 3.3?

I was being sincere when I asked the above questions.  Could you
describe how you handle RCU patches across releases and if there is a
fix for the 3.3-rcX issue Eric reported that is going into 3.3?

I know you're quite busy, but I'd like to understand your thinking so I
know what to expect going forward.

josh
