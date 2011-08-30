Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1H3UuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:50:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10819 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1H3UuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:50:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114101878"
Date: Tue, 30 Aug 2011 15:50:20 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch v2 21/35] Hexagon: Add SMP support
Message-ID: <20110830205020.GB9938@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org>
 <20110830190801.707601780@codeaurora.org>
 <1314732636.14422.8.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314732636.14422.8.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:30:36PM -0700, Joe Perches wrote:
> > +		unsigned long msg = msg = ffz(~*ops);
> 
> Really?  That's unlikely to be the right code.
> Maybe just one msg?

Whoah, you're right.  Although the code does actually work.  Just need
one msg though.
 
> > +			void (*func) (void *info) =
> > +				data->func;
> 
> No need to wrap either of these.

OK, fixed.


Thanks,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
