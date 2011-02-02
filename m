Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1BBF3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:29:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1BBF3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:29:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
In-Reply-To: Tejun Heo's message of  Monday, 31 January 2011 11:38:55 +0100 <20110131103855.GD7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
X-Zippy-Says: TAPPING?  You POLITICIANS!  Don't you realize that the END of the
    ``Wash Cycle'' is a TREASURED MOMENT for most people?!
Message-Id: <20110202052845.BA860183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:28:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeap, sounds reasonable.  So, you're saying it can go away but should
> be converted to safer sleep first, right?  I'll resequence the patches.

Correct.


Thanks,
Roland
