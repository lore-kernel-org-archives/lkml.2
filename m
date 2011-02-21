Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1BUJKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:10:16 -0500
Received: from mail-bw0-f52.google.com ([209.85.214.52]:48080 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1BUJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bb0gll7xTSQI9KLcKMESuEEkSQ8STxufxAifBOdlehhYg5jLGCvMaj278TTJ6UwjTx
         6TK31gbd3cHOIfDRFJvVk5WEg4Y3RDSv6Hw2CSA2L4bFi0aWXPRVU9+m+QCip3fs7OmU
         MWOfeN7ciHlB/hzZmvP6tyeJ4YkNX3mbB3tLk=
Date: Mon, 21 Feb 2011 10:10:09 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq#for-2.6.39] workqueue: fix build failure introduced
 by s/freezeable/freezable/
Message-ID: <20110221091009.GF31267@htj.dyndns.org>
References: <20110221090354.GE31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221090354.GE31267@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 10:03:54AM +0100, Tejun Heo wrote:
> new usage of the flag.  The combination of the two creates a build
> failure after merge.  Fix it by renaming all freezeables to
> freezables.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> I pulled mainline into wq#for-2.6.39 and applied the build fix.
> #for-next updated accordingly.  Dmitry, please feel free to pull in
> the following branch for system_wq_freezable.  The branch is stable.
> HEAD is 6c9e293a1f (workqueue: fix build failure introduced by
> s/freezeable/freezable/).
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.39

Updated commit message (the first line went missing because it started
with #fixes-2.6.38), the new HEAD is 24d51add74.

Thanks.

-- 
tejun
