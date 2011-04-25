Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab1DYRMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:12:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64591 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1DYRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lvLqdS/mgaKP8/iTDeFB6C1OW1+AVefb+UBLKyZVjEoL96k7iBvkM/8la08GsSw2JV
         ALEqtKAiCE7Oi0hHXJ0qn+6iz7/zPUYNJyhTRRkU9/0iCp3v6l7F9cSm1lDAd5aaFnHy
         3GU5QUQ4E56ZMX3AzOX+YAi369cxzkDYq5+/s=
MIME-Version: 1.0
In-Reply-To: <20110425170737.GB18363@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110423180000.GD484@redhat.com>
	<20110425115253.GP17734@mtj.dyndns.org>
	<20110425160115.GC14934@redhat.com>
	<20110425162758.GD30828@mtj.dyndns.org>
	<20110425170737.GB18363@redhat.com>
Date: Mon, 25 Apr 2011 19:12:37 +0200
X-Google-Sender-Auth: 6bqFXQILpYEeDpcfJL5bOLCeFF4
Message-ID: <BANLkTi=KUNF1+AwxTr=OW40uc2tG3vgVaw@mail.gmail.com>
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs retarget_shared_pending()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 7:07 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> set_tsk_sigmask()
>
> but it is not _tsk, it is specially named set_current_blocked() to
> show that it only applies to current. And _blocked clearly shows what
> it should change, like set_current_state().

Ooh, I meant set_current_sigmask().

> OK, this is purely cosmetic, and __set_tsk_blocked() is static and has
> a single caller. Can we keep this naming for now? it would be trivial
> to rename later.

Sure, no biggie.

-- 
tejun
