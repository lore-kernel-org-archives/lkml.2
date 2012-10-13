Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2JMBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 21:09:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61929 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2JMBJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 21:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <20121012160359.GB30881@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121012160337.GA30881@redhat.com>
 <20121012160359.GB30881@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Oct 2012 10:09:36 +0900
X-Google-Sender-Auth: ykvjlcTkQ2Wfm49ehxUuh75iq4s
Message-ID: <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
Subject: Re: [PATCH 1/1] task_work: Add local_irq_enable() into task_work_run()
To: Oleg Nesterov <oleg@redhat.com>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 1:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> arch/alpha and probably some other architectures call
> do_notify_resume()->task_work_run() with irqs disabled.

I'm going to ignore this patch because I *hope* it is unnecessary
after the pull from Al that I just did.

But if that turns out to be not the case, please holler. Torsten, you
seem to be the one who reported this, can you check the current git
tree?

Thanks,

               Linus
