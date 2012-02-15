Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab2BOBNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:13:53 -0500
Received: from ozlabs.org ([203.10.76.45]:58378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab2BOBNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:13:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] usermodehelper: kill umh_wait, renumber UMH_* constants
In-Reply-To: <20120214164821.GC21185@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164821.GC21185@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 15 Feb 2012 11:39:17 +1030
Message-ID: <87ty2sc37m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 17:48:21 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> No functional changes. It is not sane to use UMH_KILLABLE with
> enum umh_wait, but obviously we do not want another argument in
> call_usermodehelper_* helpers. Kill this enum, use the plain int.

Seems like a step backwards.  Perhaps reorder the enum, but implying an
explicit range of values explicit by using an enum seems good.

But it's a minor gripe, feel free to ignore.

Entire series:
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks for this!
Rusty.
