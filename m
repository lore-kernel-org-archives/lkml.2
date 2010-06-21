Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0FURLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:11:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42162 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0FURLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QBqCLKZLg2QyMzZwsz0H6Edl25BJP/Tr/hOwdoYGb/XnAniOaDrIuhqgVFUGjXKLlN
         q4I0FY2YfsAHJYTJht8+VtXACtet48aePl9DXFJLYJ/j8rFPLUdSRrgXljO+SfvmOhLh
         XiZk/9N5IsamrueNhoGvn2i778K8b2ECitgaE=
MIME-Version: 1.0
In-Reply-To: <201006192229.21971.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
	<201006191432.04685.arnd@arndb.de>
	<201006192229.21971.arnd@arndb.de>
Date: Mon, 21 Jun 2010 10:11:04 -0700
X-Google-Sender-Auth: j1IZYR8Dp1iowVBswg8xueQAe1k
Message-ID: <AANLkTiklB3ahm2jhZ5MA_b5l1PCf21DJ1MjTHRBfDaXD@mail.gmail.com>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
From: Tony Luck <tony.luck@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 1:29 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Tony, can you confirm that with this patch added, everything's
> fine for you?

Yes.  My user mode output now looks fine with that patch applied.

Thanks

-Tony
