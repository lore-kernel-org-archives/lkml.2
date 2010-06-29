Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0F2IfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:35:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:44794 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab0F2IfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:35:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Tue, 29 Jun 2010 09:27:43 +0100
Message-ID: <vcnof7-b9p.ln1@chipmunk.wormnet.eu>
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dtor@vmware.com> wrote:
>
> VMware Tools installer requires the upstream driver to be compiled
> as a module in order to detect its presence and avoid installing
> our own version on top of it. To avoid surprises with 2 versions
> of the driver being installed and fighting with each other, let's
> force the driver to be compiled as a module unless user selects
> CONFIG_EMBEDDED.
>
*barf*

This surely is a problem in the installer and not the kernel?  Can you 
not nosey around in /sys/class/misc or where-ever your driver appears?  
If it does not, then I would probably suggest a patch to your balloon 
driver that dumps some details in there, including module version 
information.

Eugh.

-- 
Alexander Clouter
.sigmonster says: Who goeth a-borrowing goeth a-sorrowing.
                  		-- Thomas Tusser

