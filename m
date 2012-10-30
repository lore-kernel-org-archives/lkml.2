Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2J3C20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:28:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60911 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2J3C2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121029215809.GA19851@kroah.com>
References: <1351363525-17707-1-git-send-email-sj38.park@gmail.com> <20121029215809.GA19851@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 30 Oct 2012 11:28:03 +0900
Message-ID: <CAEjAshonrDA6KVk3-_mgv_D+2mBN5h6hGqYB4+p4jNjhBWrgGg@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: csr: Remove CsrEventHandle
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, I will.

Actually, I sent new patch already :)

On Tue, Oct 30, 2012 at 6:58 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Oct 28, 2012 at 03:45:24AM +0900, SeongJae Park wrote:
> > No one use CsrEventHandle, No one call functions using it as parameter.
> > So those are not need to be here.
> >
> > Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> > ---
> >  drivers/staging/csr/csr_framework_ext.h       |   61
> > -------------------------
> >  drivers/staging/csr/csr_framework_ext_types.h |    2 -
> >  2 files changed, 63 deletions(-)
>
> Sorry, but someone already did this.  Look at the linux-next tree to see
> the patch there that cleaned up part of this.  But, the second file you
> changed here still applies, so can you redo this, and the 2/2 patch and
> resend them?
>
> thanks,
>
> greg k-h
