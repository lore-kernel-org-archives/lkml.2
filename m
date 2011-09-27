Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1I0QxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:53:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1I0QxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:53:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=qyoVJFZSa+w4BQDIQnv/W/1L8NVHTxapmQ3pSA8zra6o6jeeZ6E6JBAkEe8F0RoHo
	d9UOBN366sI5vKyMqKQTA==
MIME-Version: 1.0
In-Reply-To: <20110927165920.14b00e8595d10135d2a4397a@canb.auug.org.au>
References: <20110927165920.14b00e8595d10135d2a4397a@canb.auug.org.au>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 27 Sep 2011 09:52:27 -0700
Message-ID: <CAL26m8JbvOi05irJdhtsas2=PWdy4V+hkTYHp029RAvDGnUZgA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 11:59 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the scsi-post-merge tree got conflicts in
> arch/x86/kernel/apic/apic.c, arch/x86/kernel/cpu/mcheck/therm_throt.c,
> arch/x86/kernel/cpu/mcheck/threshold.c and arch/x86/kernel/irq.c between
> commit ef14aea88fee ("x86: Call idle notifier after irq_enter()") from
> the rcu tree and commit 6a541324a31f ("The current interrupt traces from
> irq_handler_entry and irq_handler_exit") from the akpm tree.
>
> Just context changes. I fixed them up (see below) and can carry the fixes
> as necessary.


Looks good to me. Do I need to provide Acked-by?

Vaibhav Nagarnaik
