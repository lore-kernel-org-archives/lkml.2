Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1HOQkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:40:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1HOQkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:40:45 -0400
Date: Mon, 15 Aug 2011 18:40:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10]include:linux Remove pointless "@" from various
 parts of the kernel
In-Reply-To: <20110815155101.GJ2389@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1108151839570.27118@pobox.suse.cz>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com> <1313195235-4522-10-git-send-email-justinmattock@gmail.com> <20110815155101.GJ2389@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Paul E. McKenney wrote:

> > The patch series below removes some pointless "@"'s in various parts of the kernel.
> > Note: some might be useful, but then again, some just seemed a waste of space.
> > (and since the kernel is become bloated, might as well diet! even if it's a few bits)
> 
> I would like to keep the RCU "@@@", please!

Don't worry, I am not taking this whole patchset.

Justin, you are not really going to save any space in .text by removing 
comments anyway.

-- 
Jiri Kosina
SUSE Labs
