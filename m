Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0HZUt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 16:49:59 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27478 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0HZUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 16:49:56 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHZudkyrR7Ht/2dsb2JhbACgU3GiD5t3hTcEhDqFSw
X-IronPort-AV: E=Sophos;i="4.56,276,1280707200"; 
   d="scan'208";a="177565188"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, jkosina@suse.cz,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [rfc] MAINTAINERS: Remove broken URLs
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	<1282855631.1875.270.camel@Joe-Laptop>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 26 Aug 2010 13:49:55 -0700
In-Reply-To: <1282855631.1875.270.camel@Joe-Laptop> (Joe Perches's message of
	"Thu, 26 Aug 2010 13:47:11 -0700")
Message-ID: <adalj7trte4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > W:	www.openib.org/

Should be replaced by www.openfabrics.org/
I'll queue up a patch.

 - R.
