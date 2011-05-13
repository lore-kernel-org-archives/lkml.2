Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab1EMQRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:17:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483Ab1EMQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110513131904.GA2519@mail.hallyn.com>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
 <20110513025013.GA13209@mail.hallyn.com> <20110513040214.GA25270@mail.hallyn.com>
 <BANLkTim3cy8Jf3URYTW+cbr3nrdWVbsmGw@mail.gmail.com> <20110513131904.GA2519@mail.hallyn.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 May 2011 09:16:40 -0700
Message-ID: <BANLkTi=yyoMXNqGtVX9KxHjVaDVGW9uzdA@mail.gmail.com>
Subject: Re: acl_permission_check: disgusting performance
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 6:19 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Compile-tested with and without CONFIG_USERNS.

Looks ok to me. And generates good code for acl_permission_check
without CONFIG_USER_NS.

I'll see how much that function drops on the kernel profiles..

                       Linus
