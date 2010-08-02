Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0HBNx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:53:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50741 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0HBNxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ObnpNi2Bt54czFprUKiMQrCeZePUni9ry6pHiNKHFBWICOv04wHhsx6gBOyZqU1zOa
         m7CJNqmNprqNrSSbZL6YyH4QBSfT6pXrosvKsN0K0SUDEDMJwFgfulZqfH3QSxZrXbtA
         gycIYh8uaR2tRnkYUN3OFVSRkMAZ6892Rre+U=
MIME-Version: 1.0
In-Reply-To: <20100802134705.GA2836@redhat.com>
References: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com>
	<20100802134705.GA2836@redhat.com>
Date: Mon, 2 Aug 2010 16:53:24 +0300
X-Google-Sender-Auth: DbNLk1lERHx1VZ0SykTzpg6NqM8
Message-ID: <AANLkTi=k5nkUk9LOS=EGHGSq=5Qe8_L-1d3_t9byxMrt@mail.gmail.com>
Subject: Re: Boot-time dynamic debugging?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, trenn@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Aug 01, 2010 at 03:10:40PM +0300, Pekka Enberg wrote:
>> Commit 346e15beb5343c2eb8216d820f2ed8f150822b08 ("driver core: basic
>> infrastructure for per-module dynamic debug messages") removed
>> "dynamic_printk" kernel parameter from the dynamic debugging subsystem
>> (and forgot to update Documentation/kernel-parameters.txt). How can I
>> use the new subsystem for enabling boot-time dev_dbg() calls for
>> non-modular kernels?

On Mon, Aug 2, 2010 at 4:47 PM, Jason Baron <jbaron@redhat.com> wrote:
> Right now, you can not enable them dynamically from the boot command
> line (only via the debugfs file). However, Thomas Renninger, has posted
> a series to add back the boot-time functionality, see:
>
> Subject:    [patch 0/3] Dynamic Debug providing early boot debug messages via
> boot parameter
> http://marc.info/?l=linux-kernel&m=127970474426120&w=2
>
> So I intend to queue those up for 2.6.36, and also update the
> documentation.

Oh, great!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Btw, can you easily enable all dev_dbg() calls with the boot parameter?
