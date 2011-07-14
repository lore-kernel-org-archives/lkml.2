Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1GNIBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:01:30 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:55908 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752038Ab1GNIB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:01:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jul 2011 04:01:28 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LIrIGDLFxio2SdRPC0HVCduoCAn0nIrzQTb6x1q9QFHmL2nCHv1LkvP4NVcvOWg7jH4gewOjJ4g847cGfeRHa4OrpjG5o3D0hhiib/u5foufj/3MLFC35r8nrGt2uAhn;
Date: Thu, 14 Jul 2011 15:35:33 +0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH resend] pci: ARI is a PCIe v2 feature
Message-ID: <20110714153533.7f310cdf@jbarnes-e6510>
In-Reply-To: <20110713171433.GU15844@sequoia.sous-sol.org>
References: <20110713171433.GU15844@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.102.205.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 10:14:33 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> The function pci_enable_ari() may mistakenly set the downstream port
> of a v1 PCIe switch in ARI Forwarding mode.  This is a PCIe v2
> feature, and with an SR-IOV device on that switch port believing the
> switch above is ARI capable it may attempt to use functions 8-255,
> translating into invalid (non-zero) device numbers for that bus.
> This has been seen to cause Completion Timeouts and general
> misbehaviour including hangs and panics.


Thanks Chris, your earlier one is still sitting in my queue, but I
wasn't going to send it for 3.0 as it didn't seem that critical.  Do
you think it is?  If so you can send it directly to Linus with my ack
as I don't have anything else queued, or just wait until the merge
window when it will be put into the stable tree as well.

Thanks,
Jesse
