Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab1LOSny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:43:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50034 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab1LOSnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:43:52 -0500
Date: Thu, 15 Dec 2011 22:43:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, balbi@ti.com, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2] ahci: platform support for suspend/resume
Message-ID: <20111215184346.GA15602@oksana.dev.rtsoft.ru>
References: <1321643410-16102-1-git-send-email-computersforpeace@gmail.com>
 <20111118192809.GF11736@legolas.emea.dhcp.ti.com>
 <CAN8TOE-yZyHC3n+dSu9wZ=UBmenD67OHbAyrF2K_sgf0O7oUJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN8TOE-yZyHC3n+dSu9wZ=UBmenD67OHbAyrF2K_sgf0O7oUJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:13:19AM -0800, Brian Norris wrote:
> On Fri, Nov 18, 2011 at 11:28 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Nov 18, 2011 at 11:10:10AM -0800, Brian Norris wrote:
> >> Add platform hooks for custom suspend() and resume() functions. The
> >> generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
> >> from the PCI version in drivers/ata/ahci.c.
> >>
> >> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> >
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> Thanks for the review, Felipe.
> 
> What's the status on this? There have been no comments for almost a
> month. Can it be merged?

FWIW, the patch looks quite useful. Hope this will help:

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
