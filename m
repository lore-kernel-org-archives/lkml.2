Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0DILOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:14:34 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:49716 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927Ab0DILOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:14:31 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201004091114.o39BEILl018939@mercury.physics.adelaide.edu.au>
Subject: Re: 2.6.33: libata issues with VIA SATA/PATA controller
To: jeff@garzik.org (Jeff Garzik)
Date: Fri, 9 Apr 2010 20:44:18 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org (Linux IDE mailing list)
In-Reply-To: <4BBEAC83.9060301@garzik.org> from "Jeff Garzik" at Apr 09, 2010 12:26:43 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff

Following up on my previous reply:

> Also, please try the latest 2.6.34-rc kernel, as that has several fixes 
> for both pata_via and sata_via which did not make 2.6.33.

I was able to try this on the machine just before I left.  Unfortunately
2.6.34-rc3 does not fix the problem - it behaves exactly like 2.6.33.  In
terms of error messages, there is nothing more displayed beyond that which I
reported in the initial email except for this:

  SStatus 113, SControl 300

As far as I can tell, that (plus the previously reported details) is all
that's printed by the kernel in connection with the failure.

I'll look into the alternative console methods to see if I can capture a
full output from the failing kernel.  However, it will be at least two weeks
before I can do this because that's the earliest I'll be physically back at
the machine for an extended period of time (I could probably run quick tests
sooner).

Regards
  jonathan
