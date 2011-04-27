Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1D0KNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:13:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61460 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab1D0KM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v5g5Y6gB1JdzxjayV6/euKK5GJQzi2LpnqR3TnAGyPTxts7AGTjzH6gTALvd7lPDuV
         lc1C2Qwn78rKUTgv261Nv3HPMFudlfk/7Lx34RcyHzdbk7B/a0+d9h5qTOYEQR2GBLV/
         Bo9CELaDc9OT/Q5UXC3UFvPG9S62EmftO2kXU=
Date: Wed, 27 Apr 2011 12:12:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] signal: cleanup sys_sigprocmask()
Message-ID: <20110427101254.GD31015@htj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110426194822.GA8520@redhat.com>
 <20110426194943.GE8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194943.GE8520@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:49:43PM +0200, Oleg Nesterov wrote:
> Cleanup. Remove the unneeded goto's, we can simply read blocked.sig[0]
> unconditionally and then copy-to-user it if oset != NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
