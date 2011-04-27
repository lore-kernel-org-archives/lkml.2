Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab1D0KJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:09:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45556 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1D0KJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A9+JUgc5Jy7u2UZPEud13JwxpKYRI1EJB7jWbwMfgj/Ty4Jmq6cc/MVBBeT2cWDv3v
         8fbNXhS8Yv7vMWEIkUTit6KUujzySiX47sSm9rcGLBocVcXG8wrJ3cQhTHXgLVmHIMwJ
         zpCHkC0xscl8xgNTGyJWktV45cRuzABAbCwBM=
Date: Wed, 27 Apr 2011 12:09:44 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] signal: introduce do_sigtimedwait() to factor
 out compat/native code
Message-ID: <20110427100944.GB31015@htj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110426194822.GA8520@redhat.com>
 <20110426194904.GC8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194904.GC8520@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:49:04PM +0200, Oleg Nesterov wrote:
> Factor out the common code in sys_rt_sigtimedwait/compat_sys_rt_sigtimedwait
> to the new helper, do_sigtimedwait().
> 
> Add the comment to document the extra tick we add to timespec_to_jiffies(ts),
> thanks to Linus who explained this to me.
> 
> Perhaps it would be better to move compat_sys_rt_sigtimedwait() into
> signal.c under CONFIG_COMPAT, then we can make do_sigtimedwait() static.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

But please do consider adding docbook function comment to the new
helper function.

Thanks.

-- 
tejun
