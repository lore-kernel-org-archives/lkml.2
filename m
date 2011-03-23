Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1CWUiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:38:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44076 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340Ab1CWUh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=psyiEbBNj6uACURWfu2gXC4vyL/aUDNbBB7YrQxHuiK7sLBgwDLnQ181Z0U3n0zRqq
         2Oj6iQd6AqIFLQes7T0KYBrDkizOEx4xFIHGeizaMfUUn2JAwIZJ9aWazdJ7DEmSlu4A
         F2tEc+yw3I/5VtRdF0Ix053zX6t17Y9x0QJP4=
MIME-Version: 1.0
In-Reply-To: <20110119154915.a0bb2878.akpm@linux-foundation.org>
References: <4D2DEDDB.1070605@gmail.com>
	<20110119154915.a0bb2878.akpm@linux-foundation.org>
Date: Wed, 23 Mar 2011 21:36:48 +0100
X-Google-Sender-Auth: agQQAL1zDKDiVmuDgMgHl3uVy0k
Message-ID: <AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com>
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 00:49, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 12 Jan 2011 18:07:23 +0000
> Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:
>> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>

>> +static inline int append_filetype_suffix(char *buf, __u16 filetype)
>> +{
>> +     if ((__u16) -1 == filetype)
>
> unneeded cast.

My compiler tends to disagree. On current mainline, it says:

fs/adfs/adfs.h: In function ‘append_filetype_suffix’:
fs/adfs/adfs.h:115: warning: comparison is always false due to limited
range of data type

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
