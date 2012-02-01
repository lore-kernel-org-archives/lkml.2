Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2BASOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:14:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63559 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2BASOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <7102b0e278af50d27b5d61d1be5faaba1b0a091e.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
	<7102b0e278af50d27b5d61d1be5faaba1b0a091e.1327858005.git.luto@amacapital.net>
Date: Wed, 1 Feb 2012 10:14:31 -0800
X-Google-Sender-Auth: EdIiyaQz8EGof6cjw68WQJUFb34
Message-ID: <CAGXu5j+JfTHFZUgYw7vCkBajTyfG4jP19-KLCtOw9cMuymUKjQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 8:17 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> With this set, a lot of dangerous operations (chroot, unshare, etc)
> become a lot less dangerous because there is no possibility of
> subverting privileged binaries.
>
> This patch completely breaks apparmor.  Someone who understands (and
> uses) apparmor should fix it or at least give me a hint.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Looking forward to this -- it'll give us a lot more flexibility.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
