Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2KMBXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:23:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46283 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2KMBXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:23:04 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1211121717060.8225@chino.kir.corp.google.com>
References: <545706980.41498.1352739027798.JavaMail.mail@webmail19>
 <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com>
 <CA+55aFz2Kgn0mVV4ozH0g1QGKw1VE6NpgCz9taxxfbCUz2a8VA@mail.gmail.com> <alpine.DEB.2.00.1211121717060.8225@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Nov 2012 17:22:41 -0800
X-Google-Sender-Auth: qXyQqNE8S7TqvinYr-IM7H_EX6E
Message-ID: <CA+55aFwSxwjqK8CScNBWvzk=ExDqREAGAyRoZLW4zjOu4dyxqw@mail.gmail.com>
Subject: Re: OOM changes in Linux 3.7 lead to udev warnings and total breakage
 of KDE 3.5.10/TDE
To: David Rientjes <rientjes@google.com>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dave@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 5:18 PM, David Rientjes <rientjes@google.com> wrote:
>
> You want to carry a dummy tunable forever?

Feel free to make it non-dummy.

> If not, then how long if two years isn't sufficient?

What part of "We don't break user space" do you have trouble understanding?

There is no time limit. It's not about time. It's about not breaking user space.

End of discussion. I don't understand why people have such a hard time
understanding such a simple concept. If people reports it breaks
user-space, we fix it. And we keep fixing things until nobody uses the
old versions any more. Seriously, IT IS THAT SIMPLE.

                 Linus
