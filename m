Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1AGIyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:54:33 -0500
Received: from mail4.comsite.net ([205.238.176.238]:24219 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1AGIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:54:32 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: virtio-pci: add softlinks between virtio and pci
From: Milton Miller <miltonm@bga.com>
In-Repy-To: <20110105191711.GA27489@redhat.com>
References: <20110105191711.GA27489@redhat.com>
Message-Id: <virtio-pci-whynotsimplify@mdm.bga.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Gleb Natapov <gleb@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jan 2011 02:54:31 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On: Wed, 05 Jan 2011 at about 19:17:11 -0000, Michael S. Tsirkin wrote:
> We sometimes need to map between the virtio device and
> the given pci device. One such use is OS installer that
> gets the boot pci device from BIOS and needs to
> find the relevant block device. Since it can't,
> installation fails.
> 

> Supply softlinks between these to make it possible.
> 
> Gleb, could you please ack that this patch below
> will be enough to fix the installer issue that
> you see?
> 

why not remove this device anchor and put the devices
under the pci device?   Proposed patch follows as a
reply.

milton
