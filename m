Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1J0B4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:56:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1J0Bz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:55:59 -0400
Date: Wed, 26 Oct 2011 21:55:28 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111027015528.GA19696@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Randy Dunlap <rdunlap@xenotime.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Debian kernel maintainers <debian-kernel@lists.debian.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
 <20111025165142.GA25354@elliptictech.com>
 <20111025200455.GA6376@kroah.com>
 <20111025201723.GA25063@redhat.com>
 <20111025205410.GA7479@kroah.com>
 <20111026130834.GA6387@elliptictech.com>
 <874nyvnsqe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nyvnsqe.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 11:41:37AM +1030, Rusty Russell wrote:

 > I think we need a "taint_string()" function, and instead of lockdep
 > disabling itself it should note the taint string in its reports.
 > Similarly for anything else (oops already does this).

you mean like print_tainted() ?
 
	Dave
 
