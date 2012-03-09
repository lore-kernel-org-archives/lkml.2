Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2CIR3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:29:13 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35537 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab2CIR3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:29:11 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: RE: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Thread-Topic: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Thread-Index: AQHM/hMxk3iRaS4pqEOOCrKMt0Y51JZiKrpggAAKDICAAAJCQA==
Date: Fri, 9 Mar 2012 17:28:15 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD34123320369E69@G9W0755.americas.hpqcorp.net>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
 <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
 <20120309171711.GI24378@redhat.com>
In-Reply-To: <20120309171711.GI24378@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.128.116]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I register for more than one type? Like NMI_UNKNOWN | NMI_DIE (or something like that)?

-----Original Message-----
From: Don Zickus [mailto:dzickus@redhat.com] 
Sent: Friday, March 09, 2012 11:17 AM
To: Mingarelli, Thomas
Cc: x86@kernel.org; Peter Zijlstra; LKML; Wim Van Sebroeck
Subject: Re: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI callback

On Fri, Mar 09, 2012 at 04:51:09PM +0000, Mingarelli, Thomas wrote:
> Has this been tested with echo c > /proc/sysrg-trigger and the virtual NMI button via iLO?

No, because I don't know how to do that.  Though I can probably ping Tony
over here to show me how.  But for the most part the functionality hasn't
changed (the priority is always a '0' now).  Looking in
arch/x86/kernel/nmi.c shows that it will spit out a warning if two
functions register against NMI_UNKNOWN.

Cheers,
Don
