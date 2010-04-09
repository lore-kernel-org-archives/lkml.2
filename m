Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0DIEgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:36:17 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:32900 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab0DIEgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:36:13 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201004090436.o394a0ao022460@turbo.physics.adelaide.edu.au>
Subject: Re: 2.6.33: libata issues with VIA SATA/PATA controller
To: jeff@garzik.org (Jeff Garzik)
Date: Fri, 9 Apr 2010 14:06:00 +0930 (CST)
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

> A complete dmesg is definitely useful.

It's at the end of my previous post.

> Posting one from the failing kernel would be preferred, though.

Any ideas as to how I can capture it?  Since the SATA disc interfaces stop
working long before they are mounted none of the early boot messages make it
to disc.  All the interesting bits are therefore scrolled into the bit
bucket.

A serial console might be doable (is there documentation about how to set
one up?) but that would take some time to arrange - I'm only physically at
the machine in question sporadically and I'd have to rustle up another PC
ready for my next visit.  It could be done, but might take some time.

> That will show us libata boot messages as well as the failures you are
> seeing, in full detail.

For sure.  In terms of the detailed failure messages what I posted
previously is about all that was shown.

> Also, please try the latest 2.6.34-rc kernel, as that has several fixes 
> for both pata_via and sata_via which did not make 2.6.33.

I'll see if I can squeeze this in this afternoon and report back.

Regards
  jonathan
