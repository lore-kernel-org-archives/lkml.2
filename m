Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1AMLM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:12:26 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:37079 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1AMLMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:12:24 -0500
Subject: Re: [linux-pm] Oops while going into hibernate
From: Bojan Smojver <bojan@rexursive.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        pm list <linux-pm@lists.linux-foundation.org>,
        "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
        LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
	 <20110112162655.GA13496@thunk.org>
	 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
	 <20110112172646.GB13496@thunk.org>
	 <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
	 <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 22:12:20 +1100
Message-ID: <1294917140.2781.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 19:44 -0500, Theodore Tso wrote:
> It looks like somehow the pages were left marked as dirty, so the
> writeback daemons attempted writing back a page to an inode which was
> never opened read/write (and in fact as a text page
> for /usr/bin/killall, was mapped read/only).

Just out of curiosity, when this happens, is LZO compression being used
with hibernation (default in 2.6.37) or has it been disabled?

-- 
Bojan

