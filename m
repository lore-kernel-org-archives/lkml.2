Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1JJTCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:02:52 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:50105 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754426Ab1JJTCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E8F77B8.3000805@xenotime.net>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F683D.9020604@xenotime.net> <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
 <4E8F77B8.3000805@xenotime.net>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 10 Oct 2011 12:02:29 -0700
Message-ID: <CAL1RGDWXV2=cYTRAvKuZbquOPS7n-p3NJkYnrzyK_ZAbKsJy6A@mail.gmail.com>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 3:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> First I saw it was in today's linux-next (20111007).

Got it... a latent problem exposed by some include clean up, probably.

Applied, thanks.
