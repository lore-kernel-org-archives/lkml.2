Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692Ab0KQMBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:01:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33659 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0KQMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:01:32 -0500
Date: Wed, 17 Nov 2010 13:01:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] [rfc] dcache scaling part 1
Message-ID: <20101117120128.GC23656@basil.fritz.box>
References: <20101116140900.039761100@kernel.dk>
 <877hgcrzgd.fsf@basil.nowhere.org>
 <20101117111947.GA5218@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117111947.GA5218@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I haven't looked at doing semantic patches. I suspect it might be
> a bit too hard to write.
> 
> Really, *most* filesystems do not play silly games with dcache_lock,
> and those that don't are pretty easy. Ones that do need more thought
> than semantic patch could probably apply.

The advantage of using the semantic patch is that it catches
error paths and unusal constructions which are bad for grep better. 
It does not replace hand review and some hand modification of course.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
