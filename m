Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0JVNkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:40:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54854 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0JVNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mCMxbcZulCiVyTNASKPbdeguVaa9OmTxOEDcKH8axL8YfnxuVwrXtzdMyrr/yqB0p6
         6AnhCU3oi8Kb/gXPIK03iWo+i1/B9rEyktSseraF/K2d5QWGL63g0PAkjNRzoORwIYeu
         qTXmwwU+YVMHiQRuJMjpGdlvL2c7NI+EN7LOQ=
MIME-Version: 1.0
In-Reply-To: <20101022135804.6f55be40@lxorguk.ukuu.org.uk>
References: <AANLkTinHV3qyMRsjAn92uZZp22whESpJDZUfCHcy=Eh9@mail.gmail.com>
	<20101022135804.6f55be40@lxorguk.ukuu.org.uk>
Date: Fri, 22 Oct 2010 15:40:02 +0200
Message-ID: <AANLkTimVGzQ0yxgQvbZ8UX=i414_MXc8a-0u-hW_4iNT@mail.gmail.com>
Subject: Re: [PATCH 6/9] mfd: Add support for the ST-Ericsson CG2900 Audio.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you comments Alan.

I guess I didn't put enough comments in the code or the commit message
regarding this.
In fact we (ST-Ericsson) are writing drivers that e.g. maps to the V4L
framework. They then
call the API in this driver. This driver has never been intended to
map directly towards ALSA
or V4L. We have other drivers under development that does that.

/P-G

2010/10/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Fri, 22 Oct 2010 12:39:06 +0200
> Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com> wrote:
>
>> This patch adds support for controlling audio paths within
>> the ST-Ericsson CG2900 Connectivity Combo controller.
>> This patch adds API for the Kernel as well as a char device for
>> user space stacks to control the CG2900 audio paths.
>
> I don't see any ALSA hooks for audio or any V4L hooks for the FM radio.
> Surely the audio routing wants exposing as a mixer and the audio via
> ALSA, likewise FM radio is video4linux so that it'll have the standard
> interfaces that are expected by the rest of the Linux OS.
>
> Alan
>
