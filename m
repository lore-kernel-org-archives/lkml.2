Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1JYNNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:13:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45152 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab1JYNNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <m1wrbtb4rj.fsf@fess.ebiederm.org>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
 <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com> <m1wrbtb4rj.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 15:12:46 +0200
X-Google-Sender-Auth: U3FLQurCi0XIMEJmONq51QtTH5E
Message-ID: <CA+55aFyVdz5Fcksr5=krkcy6WDVVFD75yKq4h3GJYBq411nt-g@mail.gmail.com>
Subject: Re: [GIT] Networking
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, Greg KH <gregkh@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 3:05 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> The meat of my change seems to have gotten lost in the conflict
> resolution.  Fixes in the patch below.

Duh. I was thinking about that when doing the merge, but then never
did the fixups. My bad.

Thanks, applied,

                Linus
