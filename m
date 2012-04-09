Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2DITQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:16:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61712 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2DITQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <1540670.AFBi1SpGoi@sifl>
References: <1540670.AFBi1SpGoi@sifl>
Date: Mon, 9 Apr 2012 12:16:30 -0700
X-Google-Sender-Auth: XpncvK6UKjMfDC9PLWeoE6oOuoI
Message-ID: <CAGXu5jL5nAY4=5OKhA6VPdrzkUjVuBTcLQuMxUSEv_=N=ohbzQ@mail.gmail.com>
Subject: Re: ANN: libseccomp
From: Kees Cook <keescook@chromium.org>
To: Paul Moore <paul@paul-moore.com>
Cc: libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 11:58 AM, Paul Moore <paul@paul-moore.com> wrote:
> With the seccomp patches finally stabilizing a bit, it seems like now is a
> good time to announce libseccomp: a library designed to make it easier to
> create complex, architecture independent seccomp filters.
>
>  * http://sourceforge.net/projects/libseccomp/
>  * git clone git://git.code.sf.net/p/libseccomp/libseccomp

This looks really great; nice work!

I see that the arch check happens during _gen_bpf_build_bpf(), which
is excellent. Do you have any thoughts about including a call to
prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) by default as well?

-Kees

-- 
Kees Cook
ChromeOS Security
