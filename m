Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0FCF1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:27:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:64142 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0FCF1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:27:09 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHvaBkyrR7H+/2dsb2JhbACeJXGlQpoEhRYEg0g
X-IronPort-AV: E=Sophos;i="4.53,351,1272844800"; 
   d="scan'208";a="539123228"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [announce] smatch 1.54
References: <20100109085325.GE7840@bicker>
	<adahblls0kx.fsf@roland-alpha.cisco.com>
	<20100602204147.GO5483@bicker>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Jun 2010 22:27:02 -0700
In-Reply-To: <20100602204147.GO5483@bicker> (Dan Carpenter's message of "Wed,
	2 Jun 2010 22:41:47 +0200")
Message-ID: <ada6320r8ih.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hm...  Apparently the bug is caused because I don't understand sparse
 > internals very well.  The following patch takes care of it, but I'll
 > need to look at it some more to make sure it's complete.

Thanks.  FWIW the patch gets rid of the false positives I was seeing
without introducing any obvious problems.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
