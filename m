Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1KPWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1KPWZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:25:26 -0500
Date: Wed, 16 Nov 2011 17:24:02 -0500
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error
Message-ID: <20111116222402.GB29305@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Randy Dunlap <rdunlap@xenotime.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
References: <1319773015.6759.30.camel@deadeye>
 <20111116215236.GD3366@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116215236.GD3366@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 09:52:36PM +0000, Ben Hutchings wrote:
 > Please could you ack or nak this?
 > 
 > Ben.

sorry, thought I already had.

Reviewed-by: Dave Jones <davej@redhat.com>

