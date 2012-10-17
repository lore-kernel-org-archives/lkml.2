Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab2JQTGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:06:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:44400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676Ab2JQTGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,602,1344236400"; 
   d="scan'208";a="228867647"
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v2 3/6] x86, RAS: Convert mce-inject module to debugfs
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
	<1350399175-14477-4-git-send-email-bp@amd64.org>
Date: Wed, 17 Oct 2012 12:06:35 -0700
In-Reply-To: <1350399175-14477-4-git-send-email-bp@amd64.org> (Borislav
	Petkov's message of "Tue, 16 Oct 2012 16:52:52 +0200")
Message-ID: <m2fw5csytg.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@amd64.org> writes:

> From: Borislav Petkov <borislav.petkov@amd.com>
>
> This is a module which is used for debugging MCE decoding paths so its
> userspace interface should go to debugfs, where it belongs conceptually.
>
> While at it, add a warning to the Kconfig text that this interface is
> unstable and no userspace scripts should rely all too much on it.

Nack. You broke mce-test/mce-inject, aka existing userland which is not 
allowed in Linux.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
