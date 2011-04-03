Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1DCKBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:01:43 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:38837 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1DCKBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:01:41 -0400
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Alon Levy <alevy@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20110403090149.GI4047@playa.redhat.com>
References: <1301592656.586.15.camel@jaguar>
	 <20110403090149.GI4047@playa.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 13:01:38 +0300
Message-ID: <1301824898.7875.5.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-03 at 12:01 +0300, Alon Levy wrote:
> On Thu, Mar 31, 2011 at 08:30:56PM +0300, Pekka Enberg wrote:
> > Hi all,
> > 
> > We’re proud to announce the native Linux KVM tool!
> > 
> > The goal of this tool is to provide a clean, from-scratch, lightweight
> > KVM host tool implementation that can boot Linux guest images (just a
> > hobby, won't be big and professional like QEMU) with no BIOS
> > dependencies and with only the minimal amount of legacy device
> > emulation.
> > 
> > Note that this is a development prototype for the time being: there's no
> > networking support and no graphics support, amongst other missing
> > essentials.
> 
> I've looked at how to add spice to this, the qxl device should be relatively
> easy to add as it's just another pci device and you already support the virtio
> block pci device. But to add the spice server library there needs to be some
> simple fd and timer (i.e. select/epoll) event loop, which I see is missing. Are
> you planning on adding something like that?

We have kvm__start_timer() in tools/kvm/kvm.c. Can you use that as a
base for qxl?

			Pekka

