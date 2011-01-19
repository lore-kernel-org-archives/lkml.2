Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1ASWyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:54:36 -0500
Received: from kroah.org ([198.145.64.141]:36229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1ASWyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:54:35 -0500
Date: Wed, 19 Jan 2011 13:19:48 -0800
From: Greg KH <greg@kroah.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Jon Masters <jcm@redhat.com>, Brett Rudley <brudley@broadcom.com>,
        devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Message-ID: <20110119211948.GC19944@kroah.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
 <1289880279.3916.889.camel@constitution.bos.jonmasters.org>
 <1293028287.6319.171.camel@constitution.bos.jonmasters.org>
 <1295457365.9781.108.camel@constitution.bos.jonmasters.org>
 <400C43189542CE41BC0A5B252FC90136952F059547@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F059547@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:43:18AM -0800, Arend Van Spriel wrote:
> Hi Jon,
> 
> I tried to give you a heads up. I submitted the patch last friday to
> the staging-2.6 repository. Not sure whether it has propagated to the
> 2.6.3[78] kernels yet.

No, it will take a while to get there...

Jon, can you test the patch out to let me know if it solves your problem
or not?

thanks,

greg k-h
