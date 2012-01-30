Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2A3XLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:11:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55991 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005Ab2A3XLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:11:09 -0500
X-Sasl-enc: QOyAVKIxebiE+dIr1fWNJPQaRXSVEY4iz7uyCl3q/F0L 1327965068
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 30 Jan 2012 18:10:45 -0500
In-Reply-To: <CALCETrVMYaz0F9N5aecLJCo3da6zAE3hw+kEH+UFBoajjVu0sw@mail.gmail.com>
References: <cover.1327858005.git.luto@amacapital.net>
	 <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
	 <1327960736.5355.5.camel@lenny>
	 <CALCETrWqOsWjnJOLD5TytOiSSiRE7wAwo6dRj5A7-jP-zEGa3A@mail.gmail.com>
	 <1327963309.5355.7.camel@lenny>
	 <CALCETrVMYaz0F9N5aecLJCo3da6zAE3hw+kEH+UFBoajjVu0sw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327965046.5355.16.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 14:43 -0800, Andy Lutomirski wrote:

> You don't need a setuid binary.  Just have an initscript set up the bind mounts.

The point is that dchroot is already setuid root, and calls chroot, so
it gains nothing from the ability to do it unprivileged.

(And wow, I just looked at the source, it's a setuid C++ binary!  Using
boost.  Ugh...)



