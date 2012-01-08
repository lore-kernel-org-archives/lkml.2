Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2AHWFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:05:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51340 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2AHWFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:05:05 -0500
Subject: Re: [RFC][PATCH 00/21] Crypto keys and module signing [ver #3]
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Date: Sun, 08 Jan 2012 17:02:08 -0500
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326060129.19953.3.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010822-1780-0000-0000-000002294FAC
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000244; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00103257; UDB=6.00026244; UTC=2012-01-08
 22:05:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 18:42 +0000, David Howells wrote:
> Here are a set of patches that create a framework for using cryptographic keys
> within the kernel.  The patches can also be found at:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel

Patches 2, 4, 5, and 6 are simple, straight forward Key cleanup.  Please
add my Acks.

thanks,

Mimi

