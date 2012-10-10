Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2JJFzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:55:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44665 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2JJFy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:54:56 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkjfkbYOQocuGRAKU=0P2CQCvmedhRMJZPnkUMnnxSOsqg@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <CAKgNAkjfkbYOQocuGRAKU=0P2CQCvmedhRMJZPnkUMnnxSOsqg@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 10 Oct 2012 07:54:35 +0200
Message-ID: <CAKgNAkg2zCU2UjZijuJ_JA3KjqpKmqQBLzcLsFWbx62D+Md2Cg@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending because my mobile device decided it
wanted to send HTML, which of course bounced.]

On Oct 10, 2012 12:09 AM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 10/10/2012 06:03 AM, Michael Kerrisk (man-pages) wrote:
> > Good point. A "whole hog" openat()-style interface is worth thinking about too.
>
> *Although* you could argue that you can always simply open the module
> file first, and that finit_module() is really what we should have had in
> the first place.  Then you don't need the flags since those would come
> from openat().

But in that case, I'd still stand by my original point: it may be
desirable to have a flags argument to allow future modifications to
the behavior of finit_module() (as opposed to the behavior of the file
open).
