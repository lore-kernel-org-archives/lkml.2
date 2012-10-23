Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab2JWWxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:53:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56616 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab2JWWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121023201522.GC3408@kroah.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-99-git-send-email-keescook@chromium.org>
	<20121023201522.GC3408@kroah.com>
Date: Tue, 23 Oct 2012 15:53:27 -0700
X-Google-Sender-Auth: eH088CQM2n16y7gh-qU8IKyV2wA
Message-ID: <CAGXu5jLsEJgQbriHRNNAuwpbf3TEEG-zoctS0Vj0k3R6u0rUZg@mail.gmail.com>
Subject: Re: [PATCH 098/193] drivers/net/usb: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:15 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 23, 2012 at 01:02:51PM -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/net/usb/Kconfig |   16 +++++++---------
>>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> But note, drivers/net/usb/ is handled by netdev@, not by me, so I can't
> take this, sorry.

Sounds good. David, do you want me to carry this with the others?

-Kees

-- 
Kees Cook
Chrome OS Security
