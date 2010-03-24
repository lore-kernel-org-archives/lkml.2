Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0CXNfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:35:05 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0CXNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=GKv6vtAYzvv7MDireJN6CgHObLwifEIAfmJ0Jloa4xu70teIIobhaW8x1/Z+fac5R1
         KgY+QQnamo6XPICR+ej9Nza07RFtUORKS5MxRozovMw3ZloAOjCqiZAH3X9ORxebdHRj
         j3+MpRzFA/a2tppwcTWMw3AteEJaWA02lXFFE=
MIME-Version: 1.0
In-Reply-To: <b2cc26e41003180742k435cbc7eqcf84a65791ee36c@mail.gmail.com>
References: <b2cc26e41003180742k435cbc7eqcf84a65791ee36c@mail.gmail.com>
Date: Wed, 24 Mar 2010 14:35:00 +0100
Message-ID: <b2cc26e41003240635r541cb3bdnb096a716194457c7@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 3:42 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> When you try to execute an x86 binary on a x64 system, execve()
> returns ENOENT when ld-linux.so isn't found
> Wouldn't ENOEXEC be more appropriate?
>
>> An executable is not in a recognized format, is for the wrong architecture, or has some other format error that means it cannot be executed.
>
> This just doesn't make any sense:
>
> $ ls -l
> -rwxr-xr-x 1 olaf olaf 560165 2010-03-18 15:21 xwis
> $ ./xwis
> -bash: ./xwis: No such file or directory

This is the right list, isn't it?

Olaf
