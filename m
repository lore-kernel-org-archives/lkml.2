Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab1FVSYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:24:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39246 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab1FVSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:24:48 -0400
Date: Wed, 22 Jun 2011 20:24:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110622182445.GG3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622110034.89ee399c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So.  What are your thoughts on these issues?

Sounds orthogonal to me. You have to crawl before you walk.

A better way to pass in the data would be nice, but can be always
added on top (e.g. some EFI environment variable) 

For a first try a command line argument is quite
appropiate and simple enough.

A check for removing too much memory would be nice though,
although it's just a choice between panicing early or later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
