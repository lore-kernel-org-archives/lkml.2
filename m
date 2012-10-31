Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2JaDWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:22:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43513 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2JaDWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121030173859.GA5032@kroah.com>
References: <1351563973-20392-1-git-send-email-sj38.park@gmail.com> <20121030173859.GA5032@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 31 Oct 2012 12:22:30 +0900
Message-ID: <CAEjAshq_08hrqcJDDSs6ht887socCBtCztoTjcnf-CdwXa7X6g@mail.gmail.com>
Subject: Re: [PATCH] staging: csr: Remove struct CsrEvent
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry and Thank you about that.

I will not forget it next time.

Thanks and Regards.
SeongJae Park.

On Wed, Oct 31, 2012 at 2:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 30, 2012 at 11:26:13AM +0900, SeongJae Park wrote:
> > Nobody use struct CsrEvent. So, remove it.
> > Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>
> Please put a blank line between your changelog text and your
> signed-off-by line, otherwise I have to edit it and do it by hand.  I've
> fixed it up this time.
>
> thanks,
>
> greg k-h
