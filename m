Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0IMVwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:52:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43288 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0IMVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:52:53 -0400
Date: Mon, 13 Sep 2010 22:52:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] Disallow building with gcc < 3.4
Message-ID: <20100913215243.GA12464@n2100.arm.linux.org.uk>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com> <1284408880-14414-2-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284408880-14414-2-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:14:36PM -0700, H. Peter Anvin wrote:
> Disallow building the generic kernel code with gcc < 3.4.  Earlier
> versions of gcc have known problems, and it appears that anyone who
> genuinely needs gcc 3.x can use gcc 3.4 at this point.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Reviewed-by: Russell King <rmk+kernel@arm.linux.org.uk>
