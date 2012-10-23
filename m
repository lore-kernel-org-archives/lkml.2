Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2JWCl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:41:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52131 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2JWCl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAEjAshoH2CJpnq-mt1TB6XB3i22QM+UeTKzr__ZgjHNUts3odA@mail.gmail.com>
References: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
 <507D08FE.4070902@bluegiga.com> <20121022205626.GA4368@kroah.com> <CAEjAshoH2CJpnq-mt1TB6XB3i22QM+UeTKzr__ZgjHNUts3odA@mail.gmail.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 23 Oct 2012 11:41:06 +0900
Message-ID: <CAEjAshqiVPA86fYNehmAEqiiZt0tGBvhu3ntFy+7XA4oLZKtRg@mail.gmail.com>
Subject: Re: [PATCH] staging: csr: fix coding style
To: Greg KH <greg@kroah.com>
Cc: Lauri Hintsala <lauri.hintsala@bluegiga.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I think it was my mistake.

CsrThread is enclosed by macro #ifdef __KERNEL__
and it used by csr_framework_ext.h as CsrThreadHandle type(typedef
used at csr_framework_ext_types.h).

I think that's why I didn't see build failure.

So, I think I should not remove CsrThread.
If there is anything I missed or wrong, Please let me know.


Thnks and Regards.
SeongJae Park.

On Tue, Oct 23, 2012 at 11:13 AM, SeongJae Park <sj38.park@gmail.com> wrote:
> Hello,
>
>
> Thank you very much for your kindness, Greg.
>
> I tried to reply to email-list when I received Lauri's email, but I
> coudln't because my gmail service has some problems.
>
> I'm still newbie, sorry.
>
> I will send new patch that removes whole struct, as soon as
> possible(maybe 4~5 hours later).
>
>
> Thanks and Regards.
> SeongJae Park.
