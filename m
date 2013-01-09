Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3AIBqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:46:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab3AIBqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:46:02 -0500
Date: Tue, 08 Jan 2013 17:46:01 -0800 (PST)
Message-Id: <20130108.174601.1788895671912734725.davem@davemloft.net>
To: dtor@vmware.com
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <1683801.VNKd61ZM1Q@dtor-d630.eng.vmware.com>
References: <20130109002110.GB5296@kroah.com>
	<20130108.173056.1029788106028104571.davem@davemloft.net>
	<1683801.VNKd61ZM1Q@dtor-d630.eng.vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>
Date: Tue, 08 Jan 2013 17:41:44 -0800

> On Tuesday, January 08, 2013 05:30:56 PM David Miller wrote:
>> From: Greg KH <gregkh@linuxfoundation.org>
>> Date: Tue, 8 Jan 2013 16:21:10 -0800
>> 
>> > On Tue, Jan 08, 2013 at 03:59:08PM -0800, George Zhang wrote:
>> >> * * *
>> >> 
>> >> This series of VSOCK linux upstreaming patches include latest udpate from
>> >> VMware to address Greg's and all other's code review comments.
>> > 
>> > Dave, you acked these patches a while ago,
>> 
>> Really?  I'd like to see where I did that.
>> 
>> Instead, what I remember doing was deferring to the feedback these
>> folks received, stating that ideas that the virtio people had
>> mentioned should be considered instead.
>> 
>> http://marc.info/?l=linux-netdev&m=135301515818462&w=2
> 
> I believe Andy replied to Anthony's AF_VMCHANNEL post and the differences
> between the proposed solutions.

I'd much rather see a hypervisor neutral solution than a hypervisor
specific one which this certainly is.
