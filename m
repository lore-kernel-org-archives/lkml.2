Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2I0OwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:52:22 -0400
Received: from 8bytes.org ([85.214.48.195]:44479 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2I0OwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:52:21 -0400
Date: Thu, 27 Sep 2012 16:52:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Message-ID: <20120927145217.GA18962@8bytes.org>
References: <20120807134156.GP1996@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807134156.GP1996@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Sep 27 16:52:18 2012
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5064682222971235425903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 03:41:56PM +0200, Joerg Roedel wrote:
> starting with Linux 3.6-rc1 I experience this BUG on one of my test
> machines. Please let me know if you need any additional information.
> 
> [   20.271810] ------------[ cut here ]------------
> [   20.276869] kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
> [   20.284306] invalid opcode: 0000 [#1] SMP
> [   20.288806] Modules linked in: nfs4 auth_rpcgss nfs fscache lockd sunrpc kvm_intel radeon kvm ttm drm_kms_helper i7core_edac drm edac_core joydev hpilo psmouse hid_generic i2c_algo_bit serio_raw usbhid hid bnx2

I still see this BUG with 3.6-rc7. Any fix in sight?


	Joerg


