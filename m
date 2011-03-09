Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1CIWKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:10:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54192 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab1CIWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:10:34 -0500
Subject: Re: [PATCH] ARM: hw_breakpoint: Fix newlines in WARNings
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D77D6CB.402@codeaurora.org>
References: <1298633466.32588.1.camel@e102144-lin.cambridge.arm.com>
	 <1298693163-18269-1-git-send-email-sboyd@codeaurora.org>
	 <4D77D6CB.402@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 21:58:59 +0000
Message-ID: <1299707939.4971.1.camel@jazzbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 19:36 +0000, Stephen Boyd wrote:
> Will,

Hi Stephen,
> 
> On 02/25/2011 08:06 PM, Stephen Boyd wrote:
> > Will Deacon wrote:
> >>> I'd prefer the message text not to be line wrapped, even if it
> >>> violates the general line length rule, because that makes it easier to
> >>> grep for the message in the source code.
> >> Ok, that's understandable. Moving the text onto its own line will limit
> >> the damage to the line length too. Stephen - are you happy to make these
> >> changes as part of your previous patch?
> >
> 
> Do you want to take this? I'm going to submit it to the patch tracker
> tomorrow otherwise.

Please submit it to the patch system with my ack:

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will

