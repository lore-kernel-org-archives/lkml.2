Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2CIRRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:17:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab2CIRRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:17:31 -0500
Date: Fri, 9 Mar 2012 12:17:11 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Message-ID: <20120309171711.GI24378@redhat.com>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
 <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:51:09PM +0000, Mingarelli, Thomas wrote:
> Has this been tested with echo c > /proc/sysrg-trigger and the virtual NMI button via iLO?

No, because I don't know how to do that.  Though I can probably ping Tony
over here to show me how.  But for the most part the functionality hasn't
changed (the priority is always a '0' now).  Looking in
arch/x86/kernel/nmi.c shows that it will spit out a warning if two
functions register against NMI_UNKNOWN.

Cheers,
Don
