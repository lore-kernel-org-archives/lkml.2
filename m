Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0GWOmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:42:04 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:42436 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751906Ab0GWOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:42:00 -0400
Date: Fri, 23 Jul 2010 10:41:43 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Dave Airlie <airlied@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [Bug #16265] Why is kslowd accumulating so much CPU time?
Message-ID: <20100723144143.GA14650@elliptictech.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Dave Airlie <airlied@redhat.com>, Theodore Ts'o <tytso@mit.edu>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
 <tneGvaw1wLL.A.21B.E4XSMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tneGvaw1wLL.A.21B.E4XSMB@chimera>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:47 Fri 23 Jul     , Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16265
> Subject		: Why is kslowd accumulating so much CPU time?
> Submitter	: Theodore Ts'o <tytso@mit.edu>
> Date		: 2010-06-09 18:36 (45 days old)
> First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
> Message-ID	: <E1OMQ88-0002a1-Gb@closure.thunk.org>
> References	: http://marc.info/?l=linux-kernel&m=127610857819033&w=4

I actually haven't been able to reproduce with kernels since a couple
weeks ago (still reproducible if I go back to 2.6.35-rc3, though).
Seems to be fixed somehow, can anyone else confirm?

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
