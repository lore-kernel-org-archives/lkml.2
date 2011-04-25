Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab1DYKwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:52:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54858 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab1DYKwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jAS88ERtIgizkTS2BhKdFM9WplhM7m3SaAczyKQGlEEW6MbLH2QSgbJaure2ha6frn
         vgzeAvbK0cQSPfwatJ8ULiygKz7Lp5eoW7b4JR5Wi4ziRdR1cpHIAS7o7/N2chwbS8qT
         LISPkwvHfedPEj2Ubmm1o1sED32D1HxUgN+8Q=
Date: Mon, 25 Apr 2011 12:52:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
 shared/unblocked signals only
Message-ID: <20110425105229.GE17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134501.GC15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134501.GC15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:45:01PM +0200, Oleg Nesterov wrote:
> -static void retarget_shared_pending(struct task_struct *tsk)
> +static void retarget_shared_pending(struct task_struct *tsk, sigset_t *set)

Hmm... @set?  Maybe a name which refelcts its purpose, say @target or
@consider would be better?  Also, it would be really great to have
docbook function comment describing the parameter.

Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
