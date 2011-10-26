Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1JZEwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:52:00 -0400
Received: from ozlabs.org ([203.10.76.45]:53816 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1JZEv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:51:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Oct 2011 14:30:50 +1030
Message-ID: <874nywpfkd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 11:48:19 +0200, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Modern SoCs typically employ a central symmetric multiprocessing (SMP)
> application processor running Linux, with several other asymmetric
> multiprocessing (AMP) heterogeneous processors running different instances
> of operating system, whether Linux or any other flavor of real-time OS.

OK, I'm not even sure who this should go through, but no objections here
but one:

virtio-spec.txt is a derived document, so I'd prefer that patch to go
through me so I can patch the (LyX) master copy.

Thanks!
Rusty.
