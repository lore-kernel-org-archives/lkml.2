Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424632Ab2LFRUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:20:23 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:42577 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423012Ab2LFRUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:20:22 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjlRAD/TwFBV5qjOPGdsb2JhbABEhUsiAYUAszsXAwEBAQE4NIIeAQEEATocEwEPBQsIAw44FCUKGhOICgrCURSQB2EDlgKFe4NTiW4
X-IronPort-AV: E=Sophos;i="4.84,230,1355094000"; 
   d="scan'208";a="459423345"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 18:22:25 +0100
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206172225.GA978@polaris.bitmath.org>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206161934.GA17258@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Still travelling and am not in a position to test this properly :(.
> However, this bug feels very similar to a bug in the migration scanner where
> a pfn_valid check is missed because the start is not aligned.  Henrik, when
> did this start happening? I would be a little surprised if it started between
> 3.6 and 3.7-rcX but maybe it's just easier to hit now for some reason. How
> reproducible is this? Is there anything in particular you do to trigger the
> oops? Does the following patch help any? It's only compile tested I'm afraid.

I managed to trigger the path several times with a small
memory-intensive program, and since I am still here,

    Tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks!
Henrik
