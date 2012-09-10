Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2IJPNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:13:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37533 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2IJPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120908083142.GA4959@osiris.de.ibm.com>
References: <20120908083142.GA4959@osiris.de.ibm.com>
Date: Mon, 10 Sep 2012 08:13:03 -0700
X-Google-Sender-Auth: y40LUXoTQA2qjqCQBO7vT5g4Cec
Message-ID: <CAGXu5jJ88-Fv931s-rAx_C1gUhponBUiWjA-XsfCPcLugLYQvw@mail.gmail.com>
Subject: Re: [PATCH] samples/seccomp: fix 31 bit build on s390
From: Kees Cook <keescook@chromium.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 1:31 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On s390 the flag to force 31 builds is -m31 instead of -m32 unlike
> on all (?) other architectures.
>
> Fixes this compile error:
>
>   HOSTCC  samples/seccomp/bpf-direct.o
> cc1: error: unrecognized command line option "-m32"
> make[2]: *** [samples/seccomp/bpf-direct.o] Error 1
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks for the catch!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
