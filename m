Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1FSPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:09:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56269 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab1FSPJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N2PVvg5tWYSd+kUshkZuISMzW4ENJJQMdWUdh0x0Fv2iDqkSz6R7oGE/zEYh3mOL7y
         0hHIhIGx1nSKpwfCLXO5dbL2YndMN5Kznvy7/0XK55aAlCwXfF2we86fpPR0Lvcn45DH
         6xvjPxkdoP3flWfqCcuDUsdcLejl9wgCj9+IE=
MIME-Version: 1.0
In-Reply-To: <1308483825-6023-11-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	<1308483825-6023-11-git-send-email-jonas@southpole.se>
Date: Sun, 19 Jun 2011 17:09:54 +0200
Message-ID: <BANLkTiniGVKrCJXcjBGdmQdqsbfOZ_-agw@mail.gmail.com>
Subject: Re: [PATCH 10/19] OpenRISC: System calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 1:43 PM, Jonas Bonn <jonas@southpole.se> wrote:
> +asmlinkage int _sys_vfork(struct pt_regs *regs)
> +{
> +       /* This doesn't seem to work */
> +//        return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);

Just being curious, why does that not work?

> +       /* This works */
> +        return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);

This looks very odd.

> +}

-- 
Thanks,
//richard
