Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1ELJVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:21:33 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:59517 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1ELJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:21:31 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110511091405.1266a34e@jbarnes-desktop>
References: <20110511084354.49eee757@jbarnes-desktop>
	 <1305129632-2646-1-git-send-email-ian.campbell@citrix.com>
	 <20110511091405.1266a34e@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:21:06 +0100
Message-ID: <1305192066.26692.478.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] acpiphp: assume device is in state D0 after powering
 on a slot.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 09:14 -0700, Jesse Barnes wrote:
> On Wed, 11 May 2011 17:00:32 +0100
> Ian Campbell <ian.campbell@citrix.com> wrote:
> 
> > Devices which do not support PCI configuration space based power
> > management may not otherwise be enabled.
[...]
> applied to linux-next, thanks.

Thanks Jesse.

Ian.
-- 
Ian Campbell
Current Noise: Centurions Ghost - Hyena Circle

I've been there.

