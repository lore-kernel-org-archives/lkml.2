Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0CWCYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:24:45 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:40309 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0CWCYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IBne5fEtqhzYyyIcbsE6oA96LVf0TbJE94qgnDxFjg0uv1PvyWpys/feiFr/wJR+rS
         OF/HxHCW2BaxqsYjJO1uBgJjK8obIFh3r7brN5gBUEl2LhtKWn0PEJTf9R2FaxQpBjyG
         TBy5zYikFvGb6S4z4C23IYakjgJ8VQqHDHVhw=
MIME-Version: 1.0
In-Reply-To: <201003222115.21861.chris2553@googlemail.com>
References: <201003222115.21861.chris2553@googlemail.com>
Date: Tue, 23 Mar 2010 10:24:42 +0800
Message-ID: <2375c9f91003221924k1a3af00ewfee32167c96fac27@mail.gmail.com>
Subject: Re: Build error with v2.6.34-rc2-51-g7b1f513
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 5:15 AM, Chris Clayton <chris2553@googlemail.com> wrote:
> Hi,
>
> Commit 45575f5a426c01ec68cd33d998267ba2f6278fac seems to be causing the build
> error shown below on i386:
>
>  CC      ipc/syscall.o
>  ipc/syscall.c:17: error: conflicting types for 'sys_ipc'
>  include/linux/syscalls.h:691: note: previous declaration of 'sys_ipc' was
> here
>  make[1]: *** [ipc/syscall.o] Error 1
>  make: *** [ipc] Error 2
>  make: *** Waiting for unfinished jobs....
>
> I can see that changing the type of the third arg to sys_ipc in
> include/linux/syscalls.h would probably avoid the error, but I am not
> knowledgeable enough to know whether that would be the right thing to do.
>
> Happy to test a patch, but please cc me as I'm not subscribed.

Linus already fixed this in his tree. Please check out.

Thanks.
