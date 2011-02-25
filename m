Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1BYBgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:36:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36785 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab1BYBgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:36:09 -0500
Date: Fri, 25 Feb 2011 02:36:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110225013608.GL5818@one.firstfloor.org>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org> <1298425922-23630-9-git-send-email-andi@firstfloor.org> <1298587384.9138.23.camel@nimitz> <20110224231449.GE23252@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224231449.GE23252@random.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've a micropreference in having it in split_huge_page succeeding path
> after __split_huge_page returns, as the __ function is where the
> brainer code is and statcode to me is annoying to read mixed in the
> more complex code. Not that it makes any practical difference though.

Thanks for the improvements.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
