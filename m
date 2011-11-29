Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1K2ANf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:13:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:21591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1K2ANe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80882661"
From: Andi Kleen <andi@firstfloor.org>
To: Stan Shebs <stanshebs@earthlink.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Kernel module for global breakpoints
References: <4ED41CF7.8080002@earthlink.net>
Date: Mon, 28 Nov 2011 16:13:33 -0800
In-Reply-To: <4ED41CF7.8080002@earthlink.net> (Stan Shebs's message of "Mon,
	28 Nov 2011 15:44:55 -0800")
Message-ID: <m239d76b0y.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stan Shebs <stanshebs@earthlink.net> writes:
>
> Any and all comments appreciated! (even "this is a stupid idea"
> reactions :-) )

Isn't this doing what uprobes does? Perhaps you just need a new user
interface to uprobes.

I took a quick look at the source, but the example module seems to not
use any locking and is clearly full of nasty race conditions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
