Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707Ab0HNLoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 07:44:37 -0400
Received: from tortuga.cyrius.com ([84.45.67.90]:52366 "EHLO
	tortuga.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab0HNLog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 07:44:36 -0400
Date: Sat, 14 Aug 2010 12:44:28 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Mikael Pettersson <mikpe@it.uu.se>, Michal Marek <mmarek@suse.cz>
Cc: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: R_ARM_REL32 relocation support
Message-ID: <20100814114428.GA25336@jirafa.cyrius.com>
References: <34780qy39a4uj093a4y>
 <1280993763-15254-1-git-send-email-olof@lixom.net>
 <19546.31437.994840.466509@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19546.31437.994840.466509@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mikael Pettersson <mikpe@it.uu.se> [2010-08-05 10:48]:
> Michal Marek's patch(*) to use -fno-dwarf2-cfi-asm already exists
> and is IMO the correct solution in that it addresses the cause
> of the problem rather than its symptoms.
> 
> (*) http://lkml.org/lkml/2010/7/26/154

I cannot find Michal's patch in mainline or in RMK's patch tracker.
Michal, did you submit your patch to
http://www.arm.linux.org.uk/developer/patches/ ?
-- 
Martin Michlmayr
http://www.cyrius.com/
