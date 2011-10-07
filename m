Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1JGHKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:10:46 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:48324 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1JGHKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:10:45 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Oct 2011 03:10:44 EDT
Date: Fri, 7 Oct 2011 09:03:32 +0200
From: Bastian Blank <waldi@debian.org>
To: Greg KH <greg@kroah.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111007070332.GA13671@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <20111006195824.GA22033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111006195824.GA22033@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:58:24PM -0700, Greg KH wrote:
> On Thu, Oct 06, 2011 at 03:50:07PM -0400, Dave Jones wrote:
> > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
> > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
> We could do that in a "generic" way by setting a "in-tree" flag type
> thing for everything that is built from within the kernel build, and
> then taint if that flag is not found.

Debian uses such a patch[1] since some time.

Bastian

[1]:
http://anonscm.debian.org/viewvc/kernel/dists/trunk/linux-2.6/debian/patches/debian/module-bug-Add-TAINT_OOT_MODULE-flag.patch?revision=16914&view=markup
-- 
Only a fool fights in a burning house.
		-- Kank the Klingon, "Day of the Dove", stardate unknown
