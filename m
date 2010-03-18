Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0CRPTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:19:16 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48274 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0CRPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:19:15 -0400
Date: Thu, 18 Mar 2010 08:19:13 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN module
Message-ID: <20100318151913.GA11682@ovro.caltech.edu>
References: <1267564929-9324-1-git-send-email-iws@ovro.caltech.edu>
 <1267564929-9324-3-git-send-email-iws@ovro.caltech.edu>
 <20100317193312.GF9783@ovro.caltech.edu>
 <4BA1E609.1010401@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1E609.1010401@grandegger.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 18 Mar 2010 08:19:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 09:36:25AM +0100, Wolfgang Grandegger wrote:
> Hi Ira,
> 
> Ira W. Snyder wrote:
> > Hello SocketCAN folks,
> > 
> > Is there any feedback on this patch? I've waited two weeks without a
> > response to any part of the series. As this is the biggest patch in the
> > series, if you're fine with it, I think the other supporting patches
> > should be fairly uncontroversial.
> 
> For some strange reason this patch did not show up in my socketcan mbox,
> sorry. At least I cannot find it. Oliver, or somebody else, did you
> receive it? Nevertheless, for kernel inclusion the patch should go
> through the netdev mailing list as described in:
> 
> http://svn.berlios.de/svnroot/repos/socketcan/trunk/README.submitting-patches
> 
> It's also confusing that one 2/3 shows up on the Socketcan-core ML. At
> least 0/3 should also be presented there.
> 
> Could you please resubmit?
> 

Sure, I'll resubmit.

The patch showed up just fine on socketcan-core for me (I'm subscribed).
It also showed up on LKML (I'm not subscribed). I'll make sure to CC
everyone with patch 0/3, as well as CC'ing netdev.

Thanks,
Ira
