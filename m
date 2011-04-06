Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1DFIpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:45:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59458 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1DFIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wzno+27lcny2c5C6t9mXFYvlLpeoJ/WiJOzm+erYwTBWpoPEJdxEc0jcmqPrTynJaz
         dgUdkp1KFTmGFOCBm/3pdqvKiJWzu8llCb+tjtQLaJdXzfn7DSIcKpeIZfkoL6wVIqrL
         bwvEeOixHFlr0Ohk2pkc4b3QdVvU4xfFHX41M=
Date: Wed, 6 Apr 2011 01:44:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [Patch] workqueue: remove cancel_rearming_delayed_work[queue]()
Message-ID: <20110406084456.GA32058@mtj.dyndns.org>
References: <1302078793-2596-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302078793-2596-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 04:33:13PM +0800, Amerigo Wang wrote:
> cancel_rearming_delayed_work() and cancel_rearming_delayed_workqueue()
> can be removed now.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied to wq#for-2.6.40.  Thank you.

-- 
tejun
