Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0FLQij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:38:39 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:52087 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0FLQih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:38:37 -0400
Message-ID: <1276360709.4c13b80507f8b@imp.free.fr>
Date: Sat, 12 Jun 2010 18:38:29 +0200
From: castet.matthieu@free.fr
To: linux-kernel@vger.kernel.org
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> Special accommodations have been made for BIOS32/PCI BIOS services:
> according to BIOS32 specification
> (http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
> pages per BIOS32 service should be set executable and no pages need to
> be writeable.
>From my understanding only the service directory take 2 pages.

The no info for the pci service :
- the length field could be used to find the number of page it takes.
- could we assume data ro ?

Also for easier debugging, set_2_pages_rox should print some info.


Matthieu
