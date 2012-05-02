Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2EBOmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:42:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59565 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2EBOmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FA07B27.70501@gmail.com>
References: <201204291404.q3TE4vfN023826@drepperk.user.openhosting.com> <4FA07B27.70501@gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 2 May 2012 10:42:17 -0400
Message-ID: <CAOPLpQdmgQ=GdRiPTVaoGX_fbrYBHSrD3_zvrwsdPcH5nC_0TA@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] Install kernel-page-flags.h
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ulrich Drepper <drepper@akkadia.org>, arnd@arndb.de, davem@davemloft.net,
        hch@infradead.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 8:09 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> I'm going to ack if you can fix two things.
>  1) your current changelog looks like a chat log style. Please write formal changelog.
>  2) Please fix page-type.c too.

OK, done.

I've also sent a second patch to clean up page-type.c to compile more
cleanly with recent compilers.  One more set of patches needed to
clean it up completely.
