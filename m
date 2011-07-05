Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1GEOI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:08:59 -0400
Received: from tex.lwn.net ([70.33.254.29]:47893 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab1GEOI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:08:57 -0400
Date: Tue, 5 Jul 2011 08:08:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] viacam: Don't explode if pci_find_bus() returns NULL
Message-ID: <20110705080855.64fda748@bike.lwn.net>
In-Reply-To: <alpine.LNX.2.00.1107030952330.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107030952330.16316@swampdragon.chaosbits.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011 09:54:12 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> In the unlikely case that pci_find_bus() should return NULL
> viacam_serial_is_enabled() is going to dereference a NULL pointer and
> blow up. Better safe than sorry, so be defensive and check the
> pointer.

Extremely unlikely - that function is only called on a single architecture
where the bus is known to exist.  Still, no harm can come from checking.

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
