Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2GXSUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:20:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36375 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2GXSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120724181209.GA10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 11:20:11 -0700
X-Google-Sender-Auth: Emp0HymO2EtY2OhGGcaUVkCUido
Message-ID: <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:12 AM, Josh Boyer <jwboyer@redhat.com> wrote:
>
> +#define __NFDBITS      (8 * (int) sizeof(long int))

I don't know if the type change is needed, but who the hell uses "long int"?

Somebody is confused. Grepping the kernel sources, I am saddened to
see any of these at all. I certainly would never want to add one.

                Linus
