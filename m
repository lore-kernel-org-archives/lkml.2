Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GTQoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:44:25 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38613 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1GTQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:44:23 -0400
Date: Wed, 20 Jul 2011 18:44:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
 interaction
Message-ID: <20110720164418.GE9924@mtj.dyndns.org>
References: <20110707190301.GA25332@redhat.com>
 <20110707190324.GB25332@redhat.com>
 <20110713100404.GG2872@htj.dyndns.org>
 <20110713183322.GA12535@redhat.com>
 <20110714064457.GA3455@htj.dyndns.org>
 <20110714191233.GA20177@redhat.com>
 <20110717190337.GA18465@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717190337.GA18465@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Sun, Jul 17, 2011 at 09:03:37PM +0200, Oleg Nesterov wrote:
> > I agree, this is not the best comment... OK, I'll try to make a
> > better one. Damn this is not easy ;) and I hate the really fat
> > comments.
> 
> OK, how about v2? The patch is the same, only the comment was updated.
> Not sure it is really better though.

Heh, yeah, that's one fat ugly comment but I think the code there
deserves it. :)

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
