Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0GCCcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:32:08 -0400
Received: from ozlabs.org ([203.10.76.45]:37390 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab0GCCcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:32:06 -0400
Date: Sat, 3 Jul 2010 11:56:49 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Ettl <ettl.martin@gmx.de>
Subject: Re: [PATCH] scripts/dtc: Fix a resource leak
Message-ID: <20100703015649.GD27004@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, Martin Ettl <ettl.martin@gmx.de>
References: <1278071534-9820-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278071534-9820-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:52:14PM +0200, Michal Marek wrote:
> From: Martin Ettl <ettl.martin@gmx.de>
> 
> during a check of the current git head of the linux kernel with the
> static code analysis tool cppcheck
> (http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page)
> the tool discovered a resource leak in linux-2.6/scripts/dtc/fstree.c.
> 
> Please refer the attached patch, that fixes the issue.

I'll submit a patch for this to upstream dtc.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
