Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0DTOen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:34:43 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34726 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0DTOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:34:42 -0400
Date: Tue, 20 Apr 2010 10:31:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kiszka <jan.kiszka@web.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
Message-ID: <20100420143144.GC30011@c-98-229-117-200.hsd1.ma.comcast.net>
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org> <4BCC07C0.5050601@web.de> <alpine.LRH.2.00.1004191829220.28179@twin.jikos.cz> <4BCCB89C.50201@web.de> <alpine.LNX.2.00.1004192211140.7579@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004192211140.7579@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 10:12:04PM +0200, Jiri Kosina wrote:
> Well, if Jeff isn't actively maintaining UML any more, either you can take 
> over the maintainership yourself, or feed the non-trivial patches through 
> Andrew Morton.

Yes, these generally go through Andrew.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
