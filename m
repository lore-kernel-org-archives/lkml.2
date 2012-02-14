Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab2BNDvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:51:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2BNDvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:51:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAAsGZS5VFgFFx8KCBzqVYhxMFLNqyVMj8hmFwauMYBdS_KjFXw@mail.gmail.com>
References: <CAAsGZS5VFgFFx8KCBzqVYhxMFLNqyVMj8hmFwauMYBdS_KjFXw@mail.gmail.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 14 Feb 2012 11:51:16 +0800
Message-ID: <CAO_0yfNPHMwd00v89qnTZus0ybU-etXAA=wHanqmw5=uJ8R8Nw@mail.gmail.com>
Subject: Re: Making gmail 2 step verification work with git send-email
To: chetan loke <loke.chetan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 11:26 AM, chetan loke <loke.chetan@gmail.com> wrote:
> Hello,
>
> Ok, I know this is not a kernel question. So apologies...
> While sending a patch to linux-scsi yesterday I had to disable the
> 2-step gmail verification just to send the patch and then enabled it
> again.
>
> How do we make git work in the 2 step gmail mode?
>

+1.
Now, I use base64 to encode my application-specific password and save
this encoded password. But it is not very safe. Any good idea?

> Chetan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
