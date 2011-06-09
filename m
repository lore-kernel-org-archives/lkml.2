Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1FIUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:25:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1FIUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:25:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 22:25:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Timur Tabi <timur@freescale.com>,
        konrad.wilk@oracle.com, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, akpm@kernel.org,
        dsaxena@linaro.org, linux-console@vger.kernel.org, greg@kroah.com,
        virtualization@lists.linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <4DF12345.1040409@freescale.com> <4DF123AA.6070402@oracle.com>
In-Reply-To: <4DF123AA.6070402@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092225.08090.arnd@arndb.de>
X-Provags-ID: V02:K0:QmSwZjIOymt+KsDKOveUtB/5FUPAUX42WMFeoBDbFOB
 /bgCec3OHt0c7skGTc7ufTsFOrmoT8Lld6Yl8hghQJJzMWL62v
 eVR7DvHFKTKAyQ7rIwfNU0aR4SwSfLuLhZNdXUOQZk03Z+kwH3
 LRgZ5dY87Zsj8FkdjO9Y9wgE0ix5FgO2bAlwLruhRNwIX9XQlr
 63Az3OBDbROnF/C4bN9cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 21:48:58 Randy Dunlap wrote:
> > So is it okay to stick with 0, or do I need to pick a new number?
> 
> I wasn't suggesting that you change the 0, just note that it has conflicts,
> like other ioctls do.

We normally don't try to maintain binary compatibility with out of tree
kernel patches. That only leads to inferior interfaces finding their way
into the kernel.

	Arnd
