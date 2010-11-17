Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab0KQFIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:08:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0KQFIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:08:06 -0500
Date: Wed, 17 Nov 2010 00:07:59 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Marcus Meissner <meissner@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@osdl.org, hpa@zytor.com, mingo@elte.hu, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101117050759.GE22651@bombadil.infradead.org>
References: <20101116104600.GA24015@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116104600.GA24015@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:46:03AM +0100, Marcus Meissner wrote:
> Target of this starter patch and follow ups is removing any kind of
> kernel space address information leak from the kernel.
> 

Er. Should probably hit /proc/modules while you're at it.

--Kyle
