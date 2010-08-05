Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511Ab0HEWCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:02:12 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:48912 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934494Ab0HEWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:02:10 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPTRWkyrR7Hu/2dsb2JhbACgP3GrdZsqhToEhCAn
X-IronPort-AV: E=Sophos;i="4.55,324,1278288000"; 
   d="scan'208";a="349700617"
From: Roland Dreier <rdreier@cisco.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Best way to send several patches
References: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Aug 2010 15:02:05 -0700
In-Reply-To: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
	(Bjarke Istrup Pedersen's message of "Thu, 5 Aug 2010 23:54:09 +0200")
Message-ID: <adabp9g3ehu.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The question is, should I just send them all to this mailinglist
 > (Section 3 of Documentation/SubmittingPatches - the one with the patch
 > bomb - suggest that this is a bad idea), or how should I do it? (I
 > have only submitted a single patch before, so I didn't have to worry
 > about that back then).

I would suggest sending a small batch of patches (say, four or five at
most) and see how that goes.  That way, in case you make some mistake in
formatting or something, you don't have to send another huge pile when
you resend.

Once your initial batch is accepted and you have the hang of submitting
patches, then you can submit bigger batches.  But I would recommend
having each batch have a common theme.  For example there was the recent
series of 42 fixes for confusing if indentation -- a big batch of fixes
for the same problem in different places, which is exactly the right way
to do things.

 - Roland
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
