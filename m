Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab0FPSbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:31:31 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:46350 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759029Ab0FPSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:31:29 -0400
Date: Wed, 16 Jun 2010 14:30:51 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
Message-ID: <20100616183051.GA19635@elliptictech.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:45 Sun 13 Jun     , Rafael J. Wysocki wrote:
>  * This report has been delayed, because I had to go through all of the
>    entries and filter out the fixed ones, invalid ones etc.  Of course, I might
>    have missed some, but hopefully not too many.

This regression from 2.6.33 still seems to be missing from the list, and
is still present in 2.6.35-rc3.

  r600 CS checker rejects narrow FBO renderbuffers.
  https://bugs.freedesktop.org/show_bug.cgi?id=27609

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
