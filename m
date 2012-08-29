Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2H2Tso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:48:44 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:34119 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2H2Tsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:48:43 -0400
Date: Wed, 29 Aug 2012 21:32:20 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Madore <david+ml@madore.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109 __alloc_pages_nodemask+0x1d4/0x68c()
Message-ID: <20120829193220.GA6389@electric-eye.fr.zoreil.com>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829002548.GA7063@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Madore <david+ml@madore.org> :
[...]
> I imagine it being somehow related to the fact that it operates a
> network bridge (I imagine this because I have another identical
> machine with exactly the same kernel and a very similar config but not
> running a bridge, and the warning never pops up).

Could it not be a genuine allocation failure ?

-- 
Ueimor
