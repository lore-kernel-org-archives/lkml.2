Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab2FGPuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:50:10 -0400
Received: from 8bytes.org ([85.214.48.195]:56041 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2FGPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:50:08 -0400
Date: Thu, 7 Jun 2012 17:50:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NFS regression in v3.5-rc1: mount.nfs yells about incorrect
 mount option
Message-ID: <20120607155006.GR12795@8bytes.org>
References: <20120607150456.GO12795@8bytes.org>
 <4FD0C4C2.8020605@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD0C4C2.8020605@netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  7 17:50:06 2012
X-DSPAM-Confidence: 0.9956
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fd0cdae28381237117784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 11:12:02AM -0400, Bryan Schumaker wrote:

> Can you use `mount -v` to get more output?

Btw, it also works when I manually set the nfs-version at mount:

mount -o nfsvers=3 ...


	Joerg


