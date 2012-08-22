Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2HVMg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:36:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab2HVMg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:36:58 -0400
Date: Wed, 22 Aug 2012 14:36:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 56/74] lto, workaround: Add workaround for missing LTO symbols in igb
Message-ID: <20120822123657.GP16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-57-git-send-email-andi@firstfloor.org> <201208220843.36047.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208220843.36047.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 08:43:35AM +0000, Arnd Bergmann wrote:
> On Sunday 19 August 2012, Andi Kleen wrote:
> > -static struct e1000_mac_operations e1000_mac_ops_82575 = {
> > +/* Workaround for LTO bug */
> > +__visible struct e1000_mac_operations e1000_mac_ops_82575 = {
> 
> The comment is not very clear outside the context of this patch.
> Maybe change it to /* __visible added to work around an LTO but */.

I hope to remove this soon, just needs another fix for initcalls
first. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
