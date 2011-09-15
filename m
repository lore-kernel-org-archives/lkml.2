Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934900Ab1IOUbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:31:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640Ab1IOUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:30:59 -0400
Date: Thu, 15 Sep 2011 22:30:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 20/27] Initconst section fixes for SCSI
Message-ID: <20110915203057.GA7761@one.firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org> <1316117394-21666-21-git-send-email-andi@firstfloor.org> <1316117927.2983.74.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316117927.2983.74.camel@dabdike.hansenpartnership.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How can this possibly be correct?  You just checked in the preceding
> #elif defined() that __devinitconst wasn't defined for this leg, so if
> it's taken there'll be an instant compile failure.

It just came out of my grep. But you're right since this is dead code
it does not need to be fixed.

I'll drop the patch.

Thanks,
-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
