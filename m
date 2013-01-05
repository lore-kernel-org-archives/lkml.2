Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3AEVt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 16:49:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32939 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab3AEVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 16:49:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [5/6] ACPI / PM: Move device power management functions to device_pm.c
Date: Sat, 05 Jan 2013 22:55:32 +0100
Message-ID: <1685489.2yI0txTT2P@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUXqt1KCskvpNuGuHj84HFnnYMe-y-ceMTLwv3nxTWz4tw@mail.gmail.com>
References: <CA+icZUXqt1KCskvpNuGuHj84HFnnYMe-y-ceMTLwv3nxTWz4tw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 05, 2013 10:43:31 AM Sedat Dilek wrote:
> Just a small typo in the comments:
> ...
> +#ifdef CONFIG_PM
> ...
> +#else /* !CONFIG_PM */
> ...
> +#endif /* !CONFIG_PM */ <--- /* CONFIG_PM (without "!") */

This actually isn't a typo.  It meas that the block started by #else ends
here.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
