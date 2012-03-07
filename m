Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab2CGQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:01:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:22677 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532Ab2CGQBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115917600"
Message-ID: <1331136246.32316.39.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Wed, 07 Mar 2012 18:04:06 +0200
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another not-so-technical comment.

On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> The following patch set implements checkpointing support for
> UBI. Checkpointing is an optional feature which stores the physical to
> logical eraseblock relations in a checkpointing superblock to reduce
> the initialization time of UBI. 

So this is basically about improving scalability and "mount" time. This
has nothing to do with checkpointing most people are aware of.
Confusing...

Really, this tirm is already reserved by file-systems, things like
virtual machines where it means "freezing" the contents and doing COW
when changing the freezed blocks and guaranteeing the ability to
"roll-back" to the checkpointed data.

Please, consider an option of picking a different name. In JFFS2 a
"similar" thing was called "summaries", and even this is better than
"checkpoint", I think.

-- 
Best Regards,
Artem Bityutskiy

