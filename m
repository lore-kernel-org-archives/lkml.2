Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2CXHZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:25:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32997 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2CXHZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:25:23 -0400
Date: Sat, 24 Mar 2012 08:25:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Merge x86_32 and x86_64 cpu_idle()
Message-ID: <20120324072519.GB20145@gmail.com>
References: <20120323123313.GG13920@gmail.com>
 <1332526838-18305-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332526838-18305-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Weinberger <richard@nod.at> wrote:

> Both functions are mostly identical, so we can merge them.

Okay, so while looking at the patch I got a bit worried about 
the 'mostly' qualifier ;-)

You could ease that worry by adding an explanation to the 
changelog that itemizes the differences, explains which 
architecture is affected by the changes in what way and gives us 
the warm fuzzy feeling that everything has been considered and 
no ill can come out of using a 'mostly' identical idling 
function in the future.

( You should also pick up Frederic's ack for the next
  submission of this patch. )

Thanks,

	Ingo
