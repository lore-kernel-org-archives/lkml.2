Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1KGRFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:05:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46921 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1KGRFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:05:08 -0500
Date: Mon, 7 Nov 2011 17:04:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: hagar <hagar@iinet.net.au>
Cc: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Fwd: Kernel Power management ?? turning off used devices that
 are in use.
Message-ID: <20111107170458.GA23257@srcf.ucam.org>
References: <4EB38A44.5030606@iinet.net.au>
 <4EB38C99.10809@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB38C99.10809@iinet.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:56:25PM +0800, hagar wrote:
> 
> I have traced this behaviour to the cpu hotplug code.
> 
> I need to be able to either switch off cpu hotpluging - or at least
> prevent hotplugging certain cpu's

The kernel doesn't automatically hotplug CPUs on idle. Something in your 
userspace is doing so. I think that Ubuntu's powernap will do so under 
certain circumstances - try disabling that if you have it.

(Which doesn't alter the fact that there appears to be a bug here)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
