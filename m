Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab1FVS4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:56:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60497 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab1FVS4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:56:46 -0400
Date: Wed, 22 Jun 2011 20:56:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stefan Assmann <sassmann@kpanic.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110622185645.GH3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org> <20110622182445.GG3263@one.firstfloor.org> <20110622113851.471f116f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622113851.471f116f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If something can be grafted on later then that's of course all good.  I
> do think we should have some sort of plan in which we work out how that
> will be done.  If we want to do it, that is.
> 
> However if we go this way then there's a risk that we'll end up with
> two different ways of configuring the feature and we'll need to

You'll always have multiple ways. Whatever magic you come up for
the google BIOS or for EFI won't help the majority of users with
old crufty legacy BIOS.

So you need a "everything included" way -- and the only straight forward
way to do that that I can see is the command line.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
