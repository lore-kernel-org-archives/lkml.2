Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1JZEv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:51:58 -0400
Received: from ozlabs.org ([203.10.76.45]:60485 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1JZEv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:51:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/13] ida: make ida_simple_get/put() IRQ safe
In-Reply-To: <1319593719-19132-2-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org> <1319593719-19132-2-git-send-email-tj@kernel.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Oct 2011 15:12:17 +1030
Message-ID: <87r520nz2u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 18:48:27 -0700, Tejun Heo <tj@kernel.org> wrote:
> It's often convenient to be able to release resource from IRQ context.
> Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
> safe.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
