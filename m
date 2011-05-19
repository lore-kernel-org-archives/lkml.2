Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab1ESTSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:18:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1ESTS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XaJP05R7oBQ8nst2yW6sdISJvzotBjBMT0GWBVJCKPpma12FywcGLHiJtaR57D3WQA
         +9gsRbOxnys8Ld9zTyOD840pNurUt54X+abAoS/p5ljX2sUBxE2df2/OtAr0pWXmsgov
         n8sW4Doc20OAQvjQEML4cJ9s21V15KGyHlNLc=
MIME-Version: 1.0
In-Reply-To: <1305824936.1465.4.camel@gandalf.stny.rr.com>
References: <1305824936.1465.4.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 19 May 2011 15:18:08 -0400
X-Google-Sender-Auth: CzHjaI9vq1IMUdKqbWHtIYWWt2Q
Message-ID: <BANLkTinj5BbdKUun4ne9sY-5vE=0ZoLciQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] maccess,probe_kernel: Make write/read src const void *
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 13:08, Steven Rostedt <rostedt@goodmis.org> wrote:
> maccess,probe_kernel: Make src const void *
>
> The functions probe_kernel_write() and probe_kernel_read() do not modify
> the src pointer. Allow const pointers to be passed in without the need
> of a typecast.
>
>  arch/blackfin/mm/maccess.c |    4 ++--

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
