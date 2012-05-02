Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2EBW4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:56:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:28259 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab2EBW4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148684973"
Date: Thu, 3 May 2012 06:55:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ulrich Drepper <drepper@akkadia.org>
Cc: arnd@arndb.de, davem@davemloft.net, hch@infradead.org, hverkuil@xs4all.nl,
        kosaki.motohiro@gmail.com, laurent.pinchart@ideasonboard.com,
        linux-kernel@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH v2] Install kernel-page-flags.h
Message-ID: <20120502225559.GA6926@localhost>
References: <201205021440.q42Ee9Ki026894@drepperk.user.openhosting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205021440.q42Ee9Ki026894@drepperk.user.openhosting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 10:40:09AM -0400, Ulrich Drepper wrote:
> Programs using /proc/kpageflags need to know about the various flags.  The
> <linux/kernel-page-flags.h> provides them and the comments in the file
> indicate that it is supposed to be used by user-level code.  But the file
> is not installed.
> 
> The patch below installs the headers and marks the unstable flags as
> out-of-bounds.  The page-type tool is also adjusted to not duplicate the
> definitions
> 
> 
> Signed-off-by: Ulrich Drepper<drepper@gmail.com>
> 
>  include/linux/Kbuild              |    1 +
>  include/linux/kernel-page-flags.h |    4 ++++
>  tools/vm/page-types.c             |   28 +---------------------------
>  3 files changed, 6 insertions(+), 27 deletions(-)

Acked-by: Fengguang Wu <fengguang.wu@intel.com>

Thank you!
