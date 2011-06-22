Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab1FVU2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:28:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1FVU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:28:15 -0400
Date: Wed, 22 Jun 2011 22:28:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@elte.hu,
        rick@vanrein.org, rdunlap@xenotime.net, Nancy Yuen <yuenn@google.com>,
        Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110622202814.GK3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org> <20110622182445.GG3263@one.firstfloor.org> <20110622113851.471f116f.akpm@linux-foundation.org> <20110622185645.GH3263@one.firstfloor.org> <4E023CE3.70100@zytor.com> <20110622191558.GI3263@one.firstfloor.org> <4E024FC5.6020707@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E024FC5.6020707@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fully backward compatible way is "memmap=<address>$<length>".

This doesn't really work for patterns. badmem is about making patterns/
strides/etc.  work as far as I understand. Those are very common
with modern interleaving schemes.

Please read the original patchkit and its documentation.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
