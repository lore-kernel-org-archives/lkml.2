Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0DTN4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:56:43 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:48598 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754574Ab0DTN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:56:42 -0400
Date: Tue, 20 Apr 2010 09:56:36 -0400
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
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
Message-ID: <20100420135636.GA10674@elliptictech.com>
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
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05:15 Tue 20 Apr     , Rafael J. Wysocki wrote:
> If you know of any other unresolved regressions from 2.6.33, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.

Please list these two similar regressions from 2.6.33 in the r600 DRM:

 * r600 CS checker rejects GL_DEPTH_TEST w/o depth buffer:
           https://bugs.freedesktop.org/show_bug.cgi?id=27571

 * r600 CS checker rejects narrow FBO renderbuffers:
           https://bugs.freedesktop.org/show_bug.cgi?id=27609

Thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
