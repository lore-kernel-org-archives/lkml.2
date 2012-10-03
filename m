Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2JCHLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:11:38 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39492 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2JCHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:11:36 -0400
Subject: Re: [PATCH 0/2] PCI-Express Non-Transparent Bridge Support
From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Reply-To: nab@risingtidesystems.com
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1349213177-9985-1-git-send-email-jon.mason@intel.com>
References: <1349213177-9985-1-git-send-email-jon.mason@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Rising Tide Systems
Date: Wed, 03 Oct 2012 00:11:29 -0700
Message-ID: <1349248289.28145.165.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:26 -0700, Jon Mason wrote:
> I am submitting version 4 of the PCI-Express Non-Transparent Bridge
> patches for inclusion in 3.7.  All outstanding issues from the RFC
> process have been addressed.
> 
> version 1
> http://thread.gmane.org/gmane.linux.kernel.pci/16443
> 
> Version 2 incorporates numerous clean-ups 
> http://thread.gmane.org/gmane.linux.kernel.pci/16696
> 
> Version 3 incorporates changes to conform NTB and client devices to the
> Linux device model (per Greg KH's request).
> http://thread.gmane.org/gmane.linux.kernel.pci/17808
> 
> Version 4 removes the transport transmit tasklet (per Dave Miller's
> request).
> http://thread.gmane.org/gmane.linux.network/244491
> 

Hi Jon,

I'm really excited to see this series merged for v3.7-rc code.

Please feel free to add my:

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

to the two individual patches for an initial merge.  I'm not sure which
tree that your intending to take this code upstream via, but also feel
free to add my:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

of your maintainer-ship of /drivers/ntb/ subsystem code.

Very nice work on this series Jon !

--nab

