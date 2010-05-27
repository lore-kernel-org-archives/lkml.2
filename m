Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0E0U76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:59:58 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:18246 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab0E0U74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:59:56 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALd5/kurR7Hu/2dsb2JhbACeJnGnWZojhRMEg0I
X-IronPort-AV: E=Sophos;i="4.53,313,1272844800"; 
   d="scan'208";a="136129809"
From: Roland Dreier <rdreier@cisco.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: ath9k-devel@venema.h4ckr.net, mcgrog@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274892555-10422-1-git-send-email-justinmattock@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 27 May 2010 13:59:52 -0700
In-Reply-To: <1274892555-10422-1-git-send-email-justinmattock@gmail.com>
	(Justin P. Mattock's message of "Wed, 26 May 2010 09:49:14 -0700")
Message-ID: <adaeigxvz5j.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > -			  "Unable to stop TxDMA. Reset HAL!\n");
 > +			  "Unable to stop TxDMA. Reseting hardware!\n");

I hate to mention it but the correct spelling is "resetting."
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
