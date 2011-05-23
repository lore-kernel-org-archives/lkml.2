Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1EWQSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:18:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755699Ab1EWQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110523141034.GA11866@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com>
 <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com>
 <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com>
 <20110523141034.GA11866@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 09:17:31 -0700
Message-ID: <BANLkTimaN8U8_sWT_q_ZDZkA51jqWPHkiQ@mail.gmail.com>
Subject: Re: ptrace_resume->wake_up_process (Was: Ptrace documentation, draft #1)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 7:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> In fact ptrace_resume()->wake_up_process() is obviously wrong anyway,
> I think the patch below makes sense even for 2.6.40.

Send me a signed-off version with a somewhat cleaned-up commit
message, and we can make that happen.

Or a pull request ..

                  Linus
