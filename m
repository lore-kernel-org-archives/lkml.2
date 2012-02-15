Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2BOUaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:30:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2BOUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:30:51 -0500
Date: Wed, 15 Feb 2012 12:30:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] kmod: make __request_module() killable
Message-Id: <20120215123049.6e938eed.akpm@linux-foundation.org>
In-Reply-To: <20120214164914.GF21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
	<20120214164914.GF21185@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 17:49:14 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> As Tetsuo Handa pointed out, request_module() can stress the
> system while the oom-killed caller sleeps in TASK_UNINTERRUPTIBLE.

Whine.

Solving this problem is the entire point of the entire patchset and you
told us almost nothing about it.  Please, provide a complete
description of the problem which is being solved, so we can understand
the value of the patchset?

