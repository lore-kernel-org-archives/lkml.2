Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1KGOXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:23:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:54100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1KGOXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:23:14 -0500
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 07 Nov 2011 15:22:05 +0100
In-Reply-To: <1320323618-10375-3-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320675725.18053.40.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> @@ -35,6 +35,7 @@ config KVM
>         select KVM_MMIO
>         select TASKSTATS
>         select TASK_DELAY_ACCT
> +       select PERF_EVENTS 

Do you really want to make that an unconditional part of KVM? I know we
can't currently build x86 without perf due to that hw breakpoint
trainwreck, but people were actually wanting to solve that.


