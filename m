Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0IDHl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 03:41:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0IDHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 03:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Sb2we1XIN8MOpjvZ5mPy1f7W9/TS1iwAbV5ZCsEEeAThDawM8cUeUhWEMztIwVKtUE
         RDLuXSH4nV4SXO7hCptM26t0tIQrXTAeSb61j1JVZzlkyQwuy7DQYFPXsqbNOCu1zyqV
         7K7Gm31cyHGNGkvaiJzBqTC+8AybYzT+U7gUo=
MIME-Version: 1.0
In-Reply-To: <1283552891-13966-5-git-send-email-mark.brown314@gmail.com>
References: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com> <1283552891-13966-5-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 4 Sep 2010 15:41:36 +0800
Message-ID: <AANLkTi=oQQQdmgi5g_LL++y3dminGxXuQEQpzSKvTyRT@mail.gmail.com>
Subject: Re: [PATCH v2 4/6 RESEND] ARM: pxa27x_keypad: added wakeup event
 handler for keypad interrupts
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 4, 2010 at 6:28 AM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> mach-mmp needs to clear wake event in order to clear the keypad interrupt
>
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>

Applied.
