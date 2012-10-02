Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2JBDDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:03:41 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:41231 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221Ab2JBDDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:03:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/n2wLUaw1OWX3Nk5vCYNKh
Date: Mon, 1 Oct 2012 20:03:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 0/12] ARM: soc: updates for 3.7, first batch
Message-ID: <20121002030332.GO4840@atomide.com>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
 <CA+55aFwoDOdKv9wcqEPkE76+w2TCz+419qp94T3_70jK9dR3-A@mail.gmail.com>
 <20121002023420.GA838@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002023420.GA838@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [121001 19:36]:
> On Mon, Oct 01, 2012 at 07:22:34PM -0700, Linus Torvalds wrote:
> 
> > Anyway, you should double-check the merges, the "soc.h" one in
> > particular is suspect.
> 
> Yes, my bad for not remembering to move the tag forward. The patch is below.

Thanks, the current head is building just fine for omaps
with that fix.

Regards,

Tony
