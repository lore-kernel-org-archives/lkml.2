Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1K3SRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:17:41 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60970 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185Ab1K3SRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:17:39 -0500
X-Sasl-enc: VVDIGTWbgHNevFv5bWIKlVwDmVVSCMoOwdt8vTnLaMrq 1322677049
Date: Wed, 30 Nov 2011 20:01:46 +0900
From: Greg KH <greg@kroah.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
Message-ID: <20111130110145.GA15450@kroah.com>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:42:58PM +0000, David Howells wrote:
> 
> Here are a set of patches that create a framework for using cryptographic keys
> within the kernel.  The patches can also be found at:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel

Very nice stuff, thanks for pushing this, it's much needed.

greg k-h
