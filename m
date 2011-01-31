Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1AaEFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:05:39 -0500
Received: from ozlabs.org ([203.10.76.45]:50202 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaEFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:05:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Date: Mon, 31 Jan 2011 14:35:24 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1296442381-21652-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311435.24531.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 01:23:00 pm Amerigo Wang wrote:
> Our kdump script needs /sys/block/X/device/{vendor, model, type},
> but virtio devices don't have {model, type}, this patch adds them.
> Actually, I don't know how to fill the model field, other block devices
> seem read it from SCSI. Any comments?

This seems deeply wrong.  Can't you fix your script?  

Model might sanely map to the feature bits, but making the type the same
as the PCI type is weird...

Confused,
Rusty.
