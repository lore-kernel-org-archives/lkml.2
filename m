Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0K2Xcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:32:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46439 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0K2Xci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g5iGD0tV1rc+vu6Bl8IRkFdvdGp236Svb0DYLDsMtHTj2+H5yKxGvs8RURVGyaLcx8
         GIq5jER6SDtzRyhrta6UFX9L6fRa1J8nXWJhEdbMR4PgaZyFEUQjTIs0CG1/lR9nIW0X
         OVK0dvdEc8WSxkFTzLnodD371jiE/Z22yjJ9g=
MIME-Version: 1.0
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
Date: Mon, 29 Nov 2010 18:32:37 -0500
Message-ID: <AANLkTikgtGkKDMJBLanE0Efy3_CrY9X2ggS9h+kMTToT@mail.gmail.com>
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Arnaud Lacombe <lacombar@gmail.com>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 28, 2010 at 9:09 PM, Pavel Vasilyev <pavel@pavlinux.ru> wrote:
>
>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
>
> I test on x86_64 (AMD Opteron 285).
>
> #include <string.h>
>
Could you at least do your "performance/code analysis" [NDLR: ahem...]
in a kernel environment ? <string.h> only belongs to userland and the
"K" of lkml stands for "kernel".

Thanks,
 - Arnaud

ps: please don't send a +500k on the list, that's rude to many people.
