Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab0JGLVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 07:21:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57705 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab0JGLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 07:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=t5VN6qRbD5fSFXhQbJWD5+xjM0jfwBgQmzkbN8UE8x9vfCQOlTI1qUDpGkUhmsVJtu
         H5tweQv4fuXVY81p2j5HPthbdhr1AkLr/pIZ5kyHFIlUSSSBpBgBu9xJ1wNHuXCWm+9p
         s0/QomUntHwqLWvZxvk0v7g5kIndhSNq8TEV4=
MIME-Version: 1.0
In-Reply-To: <loom.20101007T123430-355@post.gmane.org>
References: <1286373657-3894-1-git-send-email-penberg@kernel.org>
	<loom.20101007T123430-355@post.gmane.org>
Date: Thu, 7 Oct 2010 14:21:35 +0300
X-Google-Sender-Auth: 7JXEba7ZCqoq2cjMeBk3VQeZMiM
Message-ID: <AANLkTin492VTLUW8v4HvHZ2XuAz9pLaqHix1x=Qc1P1_@mail.gmail.com>
Subject: Re: [PATCH] SLUB: Fix memory hotplug with !NUMA [OT[
From: Pekka Enberg <penberg@kernel.org>
To: el es <el.es.cr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't trim the CC lists.)

On Thu, Oct 7, 2010 at 1:44 PM, el es <el.es.cr@gmail.com> wrote:
> Pekka Enberg <penberg <at> kernel.org> writes:
>> Reported-by: Zimny Lech <napohybelskurwysynom2010 <at> gmail.com>
>
> Sorry for those not familiar with Polish language :
>
> - the email address username contains explicit content by Polish language
> standards (rough translation : kill the f**kers [or m-f])

Heh.

> - the name and surname is not likely to be real, it looks like nickname to me
> (background : Zimny means cold; yes it may be also used as surname; Lech may be
> a first name, but is also a name of a brand of beer made in Poland - together
> the phrase 'Zimny Lech' I have seen used in a TV advertisement for that brewery
> and its other (billboards etc) media. )
>
> Just FYI.

Well, as long as it's a valid e-mail address and it's not a sign-off,
I don't really mind. If people don't want credit for their work (like
reporting bugs or testing patches), it's their choice.

                        Pekka
