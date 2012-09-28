Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2I1MRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:17:39 -0400
Received: from 8bytes.org ([85.214.48.195]:45967 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab2I1MRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:17:37 -0400
Date: Fri, 28 Sep 2012 14:17:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Message-ID: <20120928121733.GD18962@8bytes.org>
References: <20120807134156.GP1996@amd.com>
 <20120927145217.GA18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927153928.GB18962@8bytes.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
 <20120927175623.GG10549@amd.com>
 <506497B9.3030601@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506497B9.3030601@netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Sep 28 14:17:34 2012
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5065955e22979202750175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 02:15:21PM -0400, Bryan Schumaker wrote:

> Double check that you're using the legacy idmapper, and not the
> keyring based one (/etc/request-key.conf shouldn't have the "create
> id_resolver * * /usr/bin/nfsidmap %k %d" line).

That should only be relevant for NFSv4, no? I am using v3 only (without
explicitly setting the version as mount option).

Anyway, I had no luck on reproducing the failure again after
re-installation of the box, either with of with-out my patches on-top. I
tried a few different config settings for NFS too, but the BUG didn't
trigger again :-/


	Joerg


