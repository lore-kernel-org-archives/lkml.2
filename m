Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2AFToG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:44:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47303 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2AFToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:44:05 -0500
Date: Fri, 6 Jan 2012 20:44:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106194400.GX11715@one.firstfloor.org>
References: <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com> <20120106094922.GU11715@one.firstfloor.org> <4F06D979020000780006AC49@nat.nue.novell.com> <20120106103734.GV11715@one.firstfloor.org> <4F06DFEF020000780006AC84@nat28.tlf.novell.com> <20120106110845.GW11715@one.firstfloor.org> <4F06F640020000780006ACDE@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06F640020000780006ACDE@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> enough beyond 292G. At some later point ->node_page_cgroup[]
> also exceeds 4G. Finally, the phys-to-machine mapping (which gets
> resized during boot) exceeds 4G when crossing the 2T boundary.

Ok it's moot then because the old systems with problem didn't have
that much memory. So you could do without an errata workaround
and just extend the moves at the minor cost of a few prefixes
(I think that is what you did in your patch)

Only hope there are no new chips with similar issues...

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
