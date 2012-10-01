Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2JAToV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:44:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab2JAToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:44:20 -0400
Date: Mon, 1 Oct 2012 21:44:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andi Kleen <andi@firstfloor.org>, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tools: Add library dependencies for static perf link
Message-ID: <20121001194413.GC16230@one.firstfloor.org>
References: <1348942428-29688-1-git-send-email-andi@firstfloor.org> <20120929185243.GB250@x4> <20121001010709.GB2628@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001010709.GB2628@tassilo.jf.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 06:07:09PM -0700, Andi Kleen wrote:
> > This is superfluous, because FLAGS_BFD has -ldl already by your change
> > above. This is cascaded downwards.
> 
> I tried to remove it, but that makes it not link again for the static build.
> Haven't looked into the causes.

Ok looking closer it seems like Fedora 16 does not have a static libbz2,
but libelf needs that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
