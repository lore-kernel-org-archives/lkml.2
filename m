Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1AMVaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:30:18 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:42237 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1AMVaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:30:15 -0500
Subject: Re: [linux-pm] Oops while going into hibernate
From: Bojan Smojver <bojan@rexursive.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        pm list <linux-pm@lists.linux-foundation.org>,
        "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
        LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110113184626.GA31800@thunk.org>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
	 <20110112162655.GA13496@thunk.org>
	 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
	 <20110112172646.GB13496@thunk.org>
	 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
	 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
	 <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
	 <20110113133612.GD2534@osiris.boeblingen.de.ibm.com>
	 <20110113184626.GA31800@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 08:30:12 +1100
Message-ID: <1294954212.2781.8.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 13:46 -0500, Ted Ts'o wrote:
> I'm still a bit concerned with the call to set the pages' PTE to be
> dirty that I found in the hibernate code, but I accept the fact that
> removing it doesn't solve the s390 crash.  It still seems wrong to me,
> and hopefully someone from linux-pm can look at that more closely. 

If I'm understanding things correctly, this should affect only the
situation when compression is not used. Otherwise, pages that are read
into by block I/O are decompressed first and copied into different
pages. No?

-- 
Bojan

