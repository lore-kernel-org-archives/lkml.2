Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AZQjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:39:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42518 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UKROLSE7N1znM+JEEu4dgsEFkDbXMC5eCiHq3+URDRJq75zJDaElPYp5WxPeciIW3G
         g/qqDsBppac/lkm5mcT79zthuR4kcwhi+1mDSRtMXsP0HzSocL081g9c3fZK8pACibfF
         KYTO8Ua09pChdiV1cm/g9Mo84vF/i6MC2IVAQ=
Date: Wed, 26 Jan 2011 17:38:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: Re: [PATCH UPDATED 21/32] fs/aio: aio_wq isn't used in memory
 reclaim path
Message-ID: <20110126163348.GP12520@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-22-git-send-email-tj@kernel.org>
 <20110126112154.GM12520@htj.dyndns.org>
 <x491v3zzkzz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491v3zzkzz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:29:36AM -0500, Jeff Moyer wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Benjamin LaHaise <bcrl@kvack.org>
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> 
> You actually missed that CC.  ;-)

Oops, sorry about that.

> > Cc: linux-aio@kvack.org
> > ---
> > Patch description updated to describe fput_work change.  If there's no
> > further objection, I'll push it through workqueue#for-2.6.39.  Thanks.
> 
> Looks good to me, based on not changing existing semantics.
> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Thanks.  Applying to workqueue tree w/ acked by added.

-- 
tejun
