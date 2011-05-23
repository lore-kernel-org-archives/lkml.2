Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1EWRGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1EWRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:06:35 -0400
Date: Mon, 23 May 2011 19:05:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH 0/2] Was: ptrace_resume->wake_up_process
Message-ID: <20110523170508.GA29328@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com> <20110523141034.GA11866@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523141034.GA11866@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Oleg Nesterov wrote:
>
> On 05/23, Oleg Nesterov wrote:
> >
> > "does nothing" is not 100% true, it does wake_up_process() but this shouldn't
> > be documented, this should be fixed.
>
> In fact ptrace_resume()->wake_up_process() is obviously wrong anyway,

So, I am going to add these 2 simple fixes to ptrace branch if they
pass the review. Imho 1/2 makes sense for 2.6.40.

Oleg.

