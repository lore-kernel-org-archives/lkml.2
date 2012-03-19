Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2CSNF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:05:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36998 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2CSNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:05:25 -0400
Date: Mon, 19 Mar 2012 14:05:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Merge x86_32 and x86_64 cpu_idle()
Message-ID: <20120319130517.GB2660@somewhere>
References: <4F63AF10.9030101@zytor.com>
 <1331934010-24740-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331934010-24740-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:40:10PM +0100, Richard Weinberger wrote:
> Both functions are mostly identical, so we can merge them.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks like a good idea.

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
