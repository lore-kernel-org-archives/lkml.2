Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0FXKWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:22:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59035 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0FXKWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:22:43 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
References: <4C225EED.5040600@codeaurora.org>
Date: Thu, 24 Jun 2010 12:22:41 +0200
In-Reply-To: <4C225EED.5040600@codeaurora.org> (Patrick Pannuto's message of
	"Wed, 23 Jun 2010 12:22:21 -0700")
Message-ID: <871vbwafwu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Pannuto <ppannuto@codeaurora.org> writes:

Overall it seems like a good improvement.

> +
> +static inline void usleep(unsigned long usecs)
> +{
> +	usleep_range(usecs, usecs);
> +}
> +
> +static inline unsigned long usleep_interruptible(unsigned long usecs)

Is the interruptible case even needed?  I assume most drivers won't
bother with that and not being interruptible for a few usecs is not a
big issue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
