Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1JZU2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:28:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34384 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1JZU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:28:33 -0400
Date: Wed, 26 Oct 2011 13:28:26 -0700
From: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] ida: make ida_simple_get/put() IRQ safe
Message-ID: <20111026202826.GE24261@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-2-git-send-email-tj@kernel.org>
 <87r520nz2u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r520nz2u.fsf@rustcorp.com.au>
1;2305;0cTo: Rusty Russell <rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 26, 2011 at 03:12:17PM +1030, Rusty Russell wrote:
> On Tue, 25 Oct 2011 18:48:27 -0700, Tejun Heo <tj@kernel.org> wrote:
> > It's often convenient to be able to release resource from IRQ context.
> > Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
> > safe.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Heh, I just realized this patch doesn't need to be part of this
series.  I originally had ida free from rcu and thus needed this but
later on removed it.  I'll route it separately.

Thank you.

-- 
tejun
