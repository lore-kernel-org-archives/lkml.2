Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0GNIli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:41:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0GNIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ITjEC6vzmGPBp9ZBTu+8rQKmns2e6pHci55mEAI5sOQrOirN4A5PXgW4utrZCEcDVE
         7RkbMQ9QeHa2YVwxMxfERkKtTuMngEA94cNrCuftWyAqUe3M8+9x6yaqWrt2EJQcx4to
         npFuXtRxJxY//t6mLr6tg80t06PKX1j112HIs=
MIME-Version: 1.0
In-Reply-To: <4C3D1BC4.5020102@kernel.org>
References: <4C3A3B27.7020009@oracle.com>
	<4C3AD94C.7070807@cs.helsinki.fi>
	<4C3B38F7.1050400@zytor.com>
	<4C3B40F3.6070009@kernel.org>
	<4C3CA5A9.6000607@cs.helsinki.fi>
	<4C3CCE05.4090505@kernel.org>
	<AANLkTimYQPaF6YH2aMBf3nprmxLFVDDYLG4gxxD3VyBa@mail.gmail.com>
	<4C3D1BC4.5020102@kernel.org>
Date: Wed, 14 Jul 2010 11:41:34 +0300
X-Google-Sender-Auth: Y99WNaZSr3geaxEJvXTArT967W8
Message-ID: <AANLkTimki4lRVJZDGB8RHldtEgj1f1MpAFt0hfbdwmcl@mail.gmail.com>
Subject: Re: [PATCH] x86: only set early_serial_base after port is initialized
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 5:07 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> putchar is using early_serial_base to check if port is initialized.
>
> So we only assign it after early_serial_init() is called.
>
> in case we need use VGA to debug early serial console.
>
> Also add display for port addr and baud.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
