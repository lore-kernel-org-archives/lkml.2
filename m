Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0GJVRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:17:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0GJVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=utIpcXYldwZOnVr22RHP1gueG9oyIW8dnGJgdd6q9CbCdOA5acEFuvmVNJWbZH/5S5
         BXLXR2wNfJKMGcoNyXbqgkrMHaCQQ+cXBBXg7VWFhb7IWQMMgJpCGsyiVk6pmKKA4IGY
         R1oWyNo+LRrXeZGDkLyEFpgo2wB4TLA12auh8=
MIME-Version: 1.0
In-Reply-To: <4C38DCD3.8020302@kernel.org>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
	<4C38DCD3.8020302@kernel.org>
Date: Sun, 11 Jul 2010 00:17:03 +0300
X-Google-Sender-Auth: wVtSdHBGHv62Ymh8PmBFINhROes
Message-ID: <AANLkTikNSrb3-o4F5YVPs_dvGi5xdGqM-P6w7OBZm6aH@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat, Jul 10, 2010 at 11:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> can you analyze "console=uart8250,io,0x3f8,115200n8" instead?
>
> that is equal to "earlyprintk=ttyS0,115200 console=ttyS0,115200"
>
> so we only use one for all.
>
> also like to kill earlyprintk=ttyS0,115200 to favor earlycon

hpa, what's your take on this?

The 'console' variant seems overly complicated to me. We can add it
but we also need to check for 'earlyprintk' as long as it's supported
by the kernel.

                        Pekka
