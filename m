Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0KJREc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:04:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63407 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab0KJREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:04:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W+RB+x76ADdKTREwnmBRYYQtR0TWwxcvt4k51zxpf5mtAx+rPiW6AKx6R37+kiHRqM
         EhPY4WfG6gpOVbXOHnCLAVu45T7vfeIxcrBHWX+p3aAHqCwvnysZLUW4lklqrXO1Z0Nx
         B06jC00UIr64Y/JoCthgu+kHGModCNGRvutpw=
MIME-Version: 1.0
In-Reply-To: <20101110164640.GV6017@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com>
	<20101109214607.GG6017@pengutronix.de>
	<86A0E76937111F4C92FABEC0A20988510523D224@az33exm21>
	<20101110164640.GV6017@pengutronix.de>
Date: Wed, 10 Nov 2010 15:04:27 -0200
Message-ID: <AANLkTinmXin65ReWsUf02ia7FMvHfeqkVeaGu6Usmdw5@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, eric@eukrea.com,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 2:46 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
...

>> Agreed, but I was unsure how to proceed with adding clock code for mx53.
>> Should I merge mx53 clock code into clock-mx51 and rename clock-mx51?
>
> Yes, to something like clock-mx51-mx53.c
>

Or maybe clock-mx5x.c would be more generic.

This way when any other MX5x processor gets added we don't need to
change the file name again.

Regards,

Fabio Estevam
