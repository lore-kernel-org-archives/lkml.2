Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1BAO3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:29:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BAO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:29:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n4IbEi8EGLfKxPPaYu17XyzSm5NYx5FkLt4SWaRyOOECtNfRLy8GTdPp1Frh5wnXJB
         fGb46g44WbGuwzvAEm6j8lzBAWEXXJCQToqMbpVdcH5E9RPuaxfARBgXzDuff4ll1cLm
         qWqkG2azpetfZp46SVdQNKNv4LNKEYEoxP/U4=
Date: Tue, 1 Feb 2011 15:29:46 +0100
From: Tejun Heo <tj@kernel.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
Message-ID: <20110201142946.GN14211@htj.dyndns.org>
References: <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
 <20110124162414.GD27510@htj.dyndns.org>
 <20110201104043.GH14211@htj.dyndns.org>
 <20110201231836D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201231836D.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:18:54PM +0900, FUJITA Tomonori wrote:
> > Ping.  Are you interested in doing the conversion?
> 
> FYI, this driver will be replaced shortly. Now I have the working
> ibmvscsis driver for the new target framework. I'll submit it this
> week. So this driver will be removed soon or later (if James prefer to
> go through the proper Documentation/feature-removal-schedule.txt
> process, it'll be for some time). You could leave this alone, I guess.

I see.  I'll drop the patch then.  Please keep in mind that I'm
planning on marking flush_scheduled_work() deprecated in linux-next in
a month or so.  create_singlethread_workqueue() will follow in the
next cycle and then create_workqueue() the next.

Thank you.

-- 
tejun
