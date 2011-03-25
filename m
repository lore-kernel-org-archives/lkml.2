Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1CYLWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:22:08 -0400
Received: from ozlabs.org ([203.10.76.45]:58696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1CYLWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:22:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>, Alessio Igor Bogani <abogani@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
In-Reply-To: <m27hbov7hq.fsf@firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org> <1300914043-2297-3-git-send-email-abogani@kernel.org> <m27hbov7hq.fsf@firstfloor.org>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 25 Mar 2011 15:44:24 +1030
Message-ID: <8739mblr2n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 08:54:57 -0700, Andi Kleen <andi@firstfloor.org> wrote:
> Alessio Igor Bogani <abogani@kernel.org> writes:
> 
> > This work was supported by a hardware donation from the CE Linux Forum.
> 
> Patch looks good to me. SORT is a nice trick, too bad it won't 
> work for the main kernel.

Why not?

If it's just that some linkers don't support SORT, can we work around it
and call sort() of the symbols in our kernel init?

Thanks,
Rusty.
