Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1GNTQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab1GNTQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:16:11 -0400
Date: Thu, 14 Jul 2011 21:12:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
	interaction
Message-ID: <20110714191233.GA20177@redhat.com>
References: <20110707190301.GA25332@redhat.com> <20110707190324.GB25332@redhat.com> <20110713100404.GG2872@htj.dyndns.org> <20110713183322.GA12535@redhat.com> <20110714064457.GA3455@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714064457.GA3455@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Tejun Heo wrote:
>
> Never mind.  I for some reason thought flipping the flag would make
> the extra step in ptrace_signal() unnecessary.  We need to clear it
> all the same so it doesn't really improve anything.  I think the
> current version should be fine

Good.

> (maybe the comment can be beefed up a
> bit?).

I agree, this is not the best comment... OK, I'll try to make a
better one. Damn this is not easy ;) and I hate the really fat
comments.

Oleg.

