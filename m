Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2KKMyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:54:17 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64872 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2KKMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
References: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
Date: Sun, 11 Nov 2012 13:54:13 +0100
Message-ID: <CAJSP0QWq35dZOdFEPJ_fh-Gbk-JatfCt5hwsAu_ysHxgOWSWvA@mail.gmail.com>
Subject: Re: [PATCH 0/3] staging: line6: replace CONFIG_LINE6_USB_DEBUG with dyndbg
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 1:52 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> Daniel Mack <zonque@gmail.com> suggested the dyndbg mechanism which allows
> dev_dbg() messages to be enabled/disabled at run-time.  This is more powerful
> than the compile-time CONFIG_LINE6_USB_DEBUG option.
>
> This patch series converts debug messages to dev_dbg() and drops the obsolete
> CONFIG_LINE6_USB_DEBUG option.
>
> Stefan Hajnoczi (3):
>   staging: line6: replace DEBUG_MESSAGES() with dev_dbg()
>   staging: line6: drop unused DEBUG_MESSAGES() macro
>   staging: line6: drop unused CONFIG_LINE6_USB_DEBUG
>
>  drivers/staging/line6/Kconfig  |  8 ------
>  drivers/staging/line6/driver.c |  6 ++---
>  drivers/staging/line6/driver.h |  6 -----
>  drivers/staging/line6/pod.c    | 57 ++++++++++++++++--------------------------
>  drivers/staging/line6/variax.c | 12 ++++-----
>  5 files changed, 28 insertions(+), 61 deletions(-)

I forgot to mention these patches apply on top of the "staging: line6:
checkpatch.pl cleanups" series I sent earlier today.

Stefan
