Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1AaKhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:37:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1AaKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XtbU2C0eMk+p6mB3cIrS6JvluX2gXA6NKiQjmgBwFFZDtKE+9tbPQFz8WDO2LIg4U+
         nm18LXEWKT6+qHwRHVeG+WDXEZlsbxA+yLmrgQ7JilyGYaXw/eGPdhEc9teJa/37FQXh
         hGqX/jznFoAAz9h3Sz+74pcwmsPwiSWcTmHa0=
Date: Mon, 31 Jan 2011 11:36:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland Dreier <roland@kernel.org>
Cc: linux-kernel@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH] RDMA: update missed converion of flush_scheduled_work()
Message-ID: <20110131103655.GC7459@htj.dyndns.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-2-git-send-email-tj@kernel.org>
 <adamxn0yujn.fsf@cisco.com>
 <20110124110654.GA11404@htj.dyndns.org>
 <AANLkTinREtRhxhrY3nwAGdDqYqCGxMX6M8HhoxXcx8if@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinREtRhxhrY3nwAGdDqYqCGxMX6M8HhoxXcx8if@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 28, 2011 at 04:40:55PM -0800, Roland Dreier wrote:
> > Commit f0626710 (d9112f11586830d22501d0e26245ea) introduced ib_wq and
> > removed the use of flush_scheduled_work(); however, during merge
> > process one chunk was lost in ib_sa_remove_one().  Fix it.
> 
> Thanks, applied.
> 
> BTW in the future if you can cc the linux-rdma@vger mailing list on RDMA patches
> that helps me out, since the patch goes into the linux-rdma patchwork
> and I'm much
> less likely to lose it in my inbox.

Oh, I see.  I'll try to remember that.

Thank you.

-- 
tejun
