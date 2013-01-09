Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3AIAVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:21:16 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54989 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3AIAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:21:15 -0500
Date: Tue, 8 Jan 2013 16:21:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        davem@davemloft.net
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
Message-ID: <20130109002110.GB5296@kroah.com>
References: <20130108235633.3719.6085.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108235633.3719.6085.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:59:08PM -0800, George Zhang wrote:
> 
> * * *
> 
> This series of VSOCK linux upstreaming patches include latest udpate from
> VMware to address Greg's and all other's code review comments.

Dave, you acked these patches a while ago, and now that I've taken the
VMCI patches that these depend on through my char-misc tree, can I take
these as well?

thanks,

greg k-h
