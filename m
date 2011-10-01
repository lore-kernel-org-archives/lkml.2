Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1JABKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 21:10:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51668 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1JABKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 21:10:47 -0400
Date: Fri, 30 Sep 2011 18:10:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20111001011042.GF2658@mtj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
 <20110915161430.GE1548@tusker>
 <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
 <20110924030718.GA29319@htj.dyndns.org>
 <CAOtvUMeGddgQK==K09uCVHOn8gbW2PaUaCiWhhOCNx8pvy8QiQ@mail.gmail.com>
 <20110930080914.GM10425@mtj.dyndns.org>
 <20110930085421.GA11756@tusker>
 <20110930085714.GB23868@mtj.dyndns.org>
 <20110930085939.GB11756@tusker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930085939.GB11756@tusker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:59:39AM +0100, Ripduman Sohan wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
> > On which CPU a rescuer is doesn't matter at all.  Using cpu_all_mask
> > is good enough.
> 
> OK.  Am I OK to assume you'll edit the original patch to do this? 
> (i.e. you're not waiting on me?)

I think it would be better if you can respin the patch w/ updated
patch description explaning why it's a good idea for cpu isolation.

Thanks.

-- 
tejun
