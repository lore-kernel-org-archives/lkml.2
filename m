Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3AIBbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:31:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35831 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3AIBa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:30:59 -0500
Date: Tue, 08 Jan 2013 17:30:56 -0800 (PST)
Message-Id: <20130108.173056.1029788106028104571.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: georgezhang@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130109002110.GB5296@kroah.com>
References: <20130108235633.3719.6085.stgit@promb-2n-dhcp175.eng.vmware.com>
	<20130109002110.GB5296@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 8 Jan 2013 16:21:10 -0800

> On Tue, Jan 08, 2013 at 03:59:08PM -0800, George Zhang wrote:
>> 
>> * * *
>> 
>> This series of VSOCK linux upstreaming patches include latest udpate from
>> VMware to address Greg's and all other's code review comments.
> 
> Dave, you acked these patches a while ago,

Really?  I'd like to see where I did that.

Instead, what I remember doing was deferring to the feedback these
folks received, stating that ideas that the virtio people had
mentioned should be considered instead.

http://marc.info/?l=linux-netdev&m=135301515818462&w=2

So definitely NACK this code and any infrastructure you've
merged which essentialy depends upon it.
