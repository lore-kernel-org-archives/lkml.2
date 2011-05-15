Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1EOXZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:25:23 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:51079 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525Ab1EOXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:25:21 -0400
Date: Sun, 15 May 2011 19:25:10 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #33242] Lockdep splat in autofs with 2.6.39-rc2
Message-ID: <20110515232509.GA11642@elliptictech.com>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
 <HA8urZ3ZRcP.A.TvC.O6vzNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HA8urZ3ZRcP.A.TvC.O6vzNB@chimera>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-15 00:18 +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
> Subject		: Lockdep splat in autofs with 2.6.39-rc2
> Submitter	: Nick Bowler <nbowler@elliptictech.com>
> Date		: 2011-04-07 19:44 (38 days old)
> Message-ID	: <20110407194403.GA29404@elliptictech.com>
> References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2

This one is tough to reproduce, but I imagine that it's still present in
mainline because I haven't heard anything about it since I was asked to
test the patch here:

  http://permalink.gmane.org/gmane.linux.kernel/1129741

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
