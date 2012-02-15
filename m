Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2BOLuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:50:04 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47907 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab2BOLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:50:01 -0500
Subject: Re: [PATCH 20/40] mn10300: Use set_current_blocked() and
 block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
In-Reply-To: <28189.1329244210@redhat.com>
References: <1329242378.3675.71.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1329219673-28711-21-git-send-email-matt@console-pimps.org>
	 <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <17603.1329234976@redhat.com>  <28189.1329244210@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 11:49:58 +0000
Message-ID: <1329306598.3675.115.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 18:30 +0000, David Howells wrote:
> Matt Fleming <matt@console-pimps.org> wrote:
> 
> > > Can this line create a race, now that it's not protected by a lock?  It is
> > > possible for current->blocked to get altered by another thread.
> > 
> > ->blocked can only ever be altered by current, not another thread. See
> > the following comment from sigprocmask() in kernel/signal.c,
> 
> Okay, I've managed to convince myself.  Feel free to my Acked-by to the
> MN10300 and FRV patches.

Thanks! I think Andrew is picking these up, unless you want to take them
through the arch trees?

-- 
Matt Fleming, Intel Open Source Technology Center

