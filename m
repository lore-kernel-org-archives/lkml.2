Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2BCDPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:15:46 -0500
Received: from ozlabs.org ([203.10.76.45]:41045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2BCDPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:15:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] add kernel param to force disable module load
In-Reply-To: <20120201023314.GA9722@darkstar.nay.redhat.com>
References: <20120201023314.GA9722@darkstar.nay.redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 03 Feb 2012 06:58:23 +1030
Message-ID: <87aa51j7yw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 10:33:14 +0800, Dave Young <dyoung@redhat.com> wrote:
> Sometimes we need to test a kernel of same version with code or config
> option changes.
> 
> We already have sysctl to disable module load, but add a kernel
> parameter will be more convenient.
> 
> Since modules_disabled is int, so here use bint type in core_param.
> TODO: make sysctl accept bool and change modules_disabled to bool

Both applied.

Thanks!
Rusty.
