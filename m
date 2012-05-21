Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab2EUSOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:14:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab2EUSOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:14:09 -0400
Date: Mon, 21 May 2012 20:12:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, tj@kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        akpm@linux-foundation.org, bharrosh@panasas.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: UMH_WAIT_EXEC->UMH_WAIT_PROC deadlock
Message-ID: <20120521181244.GA3668@redhat.com>
References: <4F6A93F5.1070202@panasas.com> <201203241028.IGJ09825.MtOVFHFJQSLOFO@I-love.SAKURA.ne.jp> <4F6D35F0.2020808@panasas.com> <20120323200028.fadf49f8.akpm@linux-foundation.org> <20120324145308.GA10023@redhat.com> <201205191121.BIF57837.FHFOtMOLJQSOFV@I-love.SAKURA.ne.jp> <87fwau4aag.fsf@rustcorp.com.au> <20120521173453.GB31803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521173453.GB31803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 05/21, Oleg Nesterov wrote:
>
> Another issue is that Tejun dislikes the usage of system_unbound_wq.
> I guess, because WQ_UNBOUND implies WQ_HIGHPRI. Btw, I do not really
> understand why. And, otoh, I don't think that __call_usermodehelper()
> should be bound to any CPU, this would look a bit strange to me.

and please note that currently khelper_wq is WQ_UNBOUND anyway.

Oleg.

