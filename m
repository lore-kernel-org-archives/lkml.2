Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2LSMLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:11:04 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39681 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2LSMK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:10:56 -0500
MIME-Version: 1.0
Date: Wed, 19 Dec 2012 20:03:01 +0800
Message-ID: <CAJd=RBBV0uRbZ3YA7BCGh9cJFAdc9N15Swjswb64rri4rrXqeg@mail.gmail.com>
Subject: Re: [PATCH 06/26] aio: Kill return value of aio_complete()
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -594,7 +591,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
>  *	Returns true if this is the last user of the request.  The
>  *	only other user of the request can be the cancellation code.
>  */

Well the comment is stale.

Hillf

>-int aio_complete(struct kiocb *iocb, long res, long res2)
>+void aio_complete(struct kiocb *iocb, long res, long res2)
