Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2JWCwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:52:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49061 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JWCwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:52:36 -0400
Date: Mon, 22 Oct 2012 19:53:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: Lauri Hintsala <lauri.hintsala@bluegiga.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: csr: fix coding style
Message-ID: <20121023025304.GA21810@kroah.com>
References: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
 <507D08FE.4070902@bluegiga.com>
 <20121022205626.GA4368@kroah.com>
 <CAEjAshoH2CJpnq-mt1TB6XB3i22QM+UeTKzr__ZgjHNUts3odA@mail.gmail.com>
 <CAEjAshqiVPA86fYNehmAEqiiZt0tGBvhu3ntFy+7XA4oLZKtRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEjAshqiVPA86fYNehmAEqiiZt0tGBvhu3ntFy+7XA4oLZKtRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:41:06AM +0900, SeongJae Park wrote:
> Hello,
> 
> 
> I think it was my mistake.
> 
> CsrThread is enclosed by macro #ifdef __KERNEL__
> and it used by csr_framework_ext.h as CsrThreadHandle type(typedef
> used at csr_framework_ext_types.h).
> 
> I think that's why I didn't see build failure.

When building the driver __KERNEL__ is defined :)

> So, I think I should not remove CsrThread.
> If there is anything I missed or wrong, Please let me know.

No, you are right, this can't be removed just yet, so all is good.

If you want to send more patches cleaning stuff up like this one, that
would be great.

thanks,

greg k-h
