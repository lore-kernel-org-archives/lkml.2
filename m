Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1DYLji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:39:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33097 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390Ab1DYLjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XilpxVxZbTRJn2ENzjvgbyXMSwOIcUFg4Rrl5TX0AyokeMB8g4nTrbBJKNCeGrRE7S
         J6Xz9lU6TclQfGObk42Ipw32geMiEMrYubMykjfQ3e/Y4+nAa3fct9PTCMQ3NuFJcjor
         vrU+Phko+uQyEcOL0G4I/U2y5dIXGQ4Sis37c=
Date: Mon, 25 Apr 2011 13:39:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
 compat/native code
Message-ID: <20110425113932.GN17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423175940.GC484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175940.GC484@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 07:59:40PM +0200, Oleg Nesterov wrote:
> Factor out the common code in sys_rt_sigtimedwait/compat_sys_rt_sigtimedwait
> to the new helper, do_sigtimedwait().
> 
> Perhaps it would be better to move compat_sys_rt_sigtimedwait() into
> signal.c under CONFIG_COMPAT, then we can make do_sigtimedwait() static.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
