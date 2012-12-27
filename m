Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2L0Sp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:45:29 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:49343 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2L0Sp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <87han82tm4.fsf@xmission.com>
References: <87han82tm4.fsf@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Dec 2012 10:45:05 -0800
X-Google-Sender-Auth: QLH-p5_-tiPlBXqm7j42p3q747M
Message-ID: <CA+55aFzBYyCVyxaejHf-EMNq6-wEh7FuowBa7UjyQfVb8dY+Zw@mail.gmail.com>
Subject: Re: [GIT PULL] namespace fixes for v3.8-rc2
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 5:04 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Linus,
>
> Please pull the for-linus git tree from:
>
>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

Ugh. Can you please fix whatever script generates these bogus
addresses? There's an extra colon there.

                  Linus
