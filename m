Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2DQBAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:00:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:51624 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab2DQBAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:00:54 -0400
Message-ID: <1334624440.25353.18.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx
 interrupt controller
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 17 Apr 2012 11:00:40 +1000
In-Reply-To: <OFAAF4BF26.BF8400B2-ONC12579E2.008226AC-C12579E3.00005051@transmode.se>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca>
	 <CACxGe6u7EUYqyZ_8tC8PFRHwS+xq7u9+fCJk+UFbrtrV-YJFvQ@mail.gmail.com>
	 <1334617419.25353.15.camel@pasglop>
	 <OFAAF4BF26.BF8400B2-ONC12579E2.008226AC-C12579E3.00005051@transmode.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 02:03 +0200, Joakim Tjernlund wrote:
> 
> If you are going to test 8xx, could you revert
> e0908085fc2391c85b85fb814ae1df377c8e0dcb,
> powerpc/8xx: Fix regression introduced by cache coherency rewrite ?
> 
> It should not be needed after I fixed up the 8xx TLB code and added a
> workaround
> for buggy dcbX instructions. 

Have you actually verified that things still work after reverting it ?

Cheers,
Ben.


