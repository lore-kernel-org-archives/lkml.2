Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0DNUxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:53:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:53:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC][PATCH v3 1/3] A device for zero-copy based on KVM virtio-net.
Date: Wed, 14 Apr 2010 22:52:43 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
References: <1270805865-16901-1-git-send-email-xiaohui.xin@intel.com> <201004142239.50299.arnd@arndb.de> <20100414204003.GC11321@redhat.com>
In-Reply-To: <20100414204003.GC11321@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004142252.43931.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UMe4LsK11bOJunXZdQTSvrmIbkHvVtmnvZoT
 yT2GBNuCeP/YPcay1manxcH2gYhGW3iRFfkNCWy/jDD2mRrwEj
 IhW0CH8TdlUb8J6h7o9ew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 22:40:03 Michael S. Tsirkin wrote:
> On Wed, Apr 14, 2010 at 10:39:49PM +0200, Arnd Bergmann wrote:
> > Well, if the guest not only wants to send data but also receive
> > frames coming from other machines, they need to get from the kernel
> > into qemu, and the only way I can see for doing that is to read
> > from this device if there is no vhost support around on the new
> > machine.
> > 
> > Maybe we're talking about different things here.
>
> mpassthrough is currently useless without vhost.
> If the new machine has no vhost, it can't use mpassthrough :)

Ok. Is that a planned feature though? vhost is currently limited
to guests with a virtio-net driver and even if you extend it to other
guest emulations, it will probably always be a subset of the qemu
supported drivers, but it may be useful to support zero-copy on other
drivers as well.

	Arnd
