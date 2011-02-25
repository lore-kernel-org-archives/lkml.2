Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1BYGIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:08:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1BYGIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:08:21 -0500
Date: Fri, 25 Feb 2011 11:38:15 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Can't build in the virtio console driver on x86_64 when the
 other virtio drivers are modular
Message-ID: <20110225060815.GB15723@amit-x200.redhat.com>
References: <20110224112819.10f59f68@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224112819.10f59f68@katamari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 24 Feb 2011 [11:28:19], Chuck Ebbert wrote:
> The virtio configuration options are inconsistent. According to this,
> every options that needs virtio will select it:
> 
>  # Virtio always gets selected by whoever wants it.
>  config VIRTIO
>         tristate
> 
> Note that it's not user-selectable, so any config file that tries to
> set it will be ignored when kconfig loads those options. And yet we
> have a whole set of options that depend on VIRTIO, like VIRTIO_CONSOLE
> for example. This makes it impossible to have VIRTIO_PCI modular and
> VIRTIO_CONSOLE built-in on x86_64, because:

Any reason to have VIRTIO_PCI modular instead of built in (on x86-64,
virtio-console won't work without virtio-pci anyway)?

		Amit
