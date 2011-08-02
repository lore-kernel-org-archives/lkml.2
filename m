Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1HBSZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:25:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:45542 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1HBSZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:25:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="3479037"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: lwn@lwn.net, stable@kernel.org
Subject: Re: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
References: <20110801215908.GA11448@tassilo.jf.intel.com>
Date: Tue, 02 Aug 2011 11:25:07 -0700
In-Reply-To: <20110801215908.GA11448@tassilo.jf.intel.com> (Andi Kleen's
	message of "Mon, 1 Aug 2011 14:59:08 -0700")
Message-ID: <m2livb1xj0.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:
>
> Patch against 2.6.35.13
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/incr/patch-2.6.35.13-14.gz
> SHA1: 88e53290e99ea6afa1868f35ffd0f1811ccfacca

There was a problem with this patch. I uploaded a fixed version, 
but it has a different checksum:

88e53290e99ea6afa1868f35ffd0f1811ccfacca  patch-2.6.35.13-14.gz

Sorry for the inconvenience.

Also I got some reports of the public git mirror's master branch
not being uptodate. The master server is uptodate, I don't know
why the mirror is stale.  Hopefully it will resolve itself
over time.

-Andi
