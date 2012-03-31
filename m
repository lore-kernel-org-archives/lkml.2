Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2CaB6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:58:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2CaB6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120330175525.eaef1ece.akpm@linux-foundation.org>
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
	<4F7646DC.8090802@nod.at>
	<20120330175525.eaef1ece.akpm@linux-foundation.org>
Date: Sat, 31 Mar 2012 02:58:02 +0100
Message-ID: <CA+2-8GAg6x04FyZwNnBbQDhpL5Stwy+s4yZmMYRX8ZCUVjYsvQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
From: Phillip Lougher <phil.lougher@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, Phillip Lougher <plougher@redhat.com>,
        linux-kernel@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 1:55 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Presumably someone else fiddled with the file, patch(1) misapplied the
> hunk and I didn't notice.
>

That was my guess, the repeated near identical sysfs entries is
confusing patch.  The stable kernels also suffer from this
misapplication, but the misapplication is random, for instance I
noticed here

http://www.mail-archive.com/stable@linux.kernel.org/msg07097.html

that the patch has been misapplied to suid_dumpable.  It looks like
all of the stable kernels need to be separately checked, and if
necessary different patches need to be generated.

> Send a fix?

My original email has the fix...

Phillip
