Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1FPIJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:09:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46146 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FPIJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DaYhFWN8TVcIiNzGSTrgVheZ8n38sbRaaOgWHdxCufYn77rvogD4s+a9pIgZDmU1fY
         A8aQqv+nejPHTmDgDcQpcnGV4n39O+85JyKBqLHoVWBHOWTiV01PRAxiqYhiSO5LoQVV
         msxyDocDI7ZO6dMlOLsITUetcrppVK9e9oQ0g=
Date: Thu, 16 Jun 2011 10:09:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jaya Kumar <jayalk@intworks.biz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: don't use flush_scheduled_work() in fb_defio
Message-ID: <20110616080913.GI8141@htj.dyndns.org>
References: <20110615145721.GA8141@htj.dyndns.org>
 <20110616065617.GB25825@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616065617.GB25825@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 03:56:18PM +0900, Paul Mundt wrote:
> >  drivers/video/fb_defio.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> I've applied it to my fbdev tree, so it should show up in -next as of
> tomorrow.
> 
> In the future, please also Cc linux-fbdev@vger.kernel.org on these
> things, as they're likely to be overlooked otherwise.

Will do so.

Thanks.

-- 
tejun
