Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2LTBJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:09:15 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:51384 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2LTBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:09:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] serial: tegra: add serial driver
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <50D1F22A.6090801@wwwdotorg.org>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <20121217171027.6AE573E0BDD@localhost> <50CF8F36.2030309@wwwdotorg.org> <20121219130151.F29CA3E0AD7@localhost> <50D1CC07.6070506@nvidia.com> <50D1F22A.6090801@wwwdotorg.org>
Date: Thu, 20 Dec 2012 01:09:02 +0000
Message-Id: <20121220010902.2116B3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 09:58:18 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 12/19/2012 07:15 AM, Laxman Dewangan wrote:
> > On Wednesday 19 December 2012 06:31 PM, Grant Likely wrote:
> >> On Mon, 17 Dec 2012 14:31:34 -0700, Stephen
> >> Warren<swarren@wwwdotorg.org>  wrote:
> >>> On 12/17/2012 10:10 AM, Grant Likely wrote:
> >>>> On Mon, 17 Dec 2012 17:40:49 +0530, Laxman
> >>>> Dewangan<ldewangan@nvidia.com>  wrote:
> >>>
> >>> Aren't we still supposed to support platform data so that it can
> >>> override what's in DT in order to fix up bad DTs? Or, has that
> >>> requirement been dropped. If it has, we can drop a bunch of code from a
> >>> variety of Tegra-specific drivers, I expect.
> >> Do you have an actual user for this? If not, then don't borrow trouble.
> >> Just drop it. Things like platform_data can always be added later only
> >> if it is needed.
> > 
> > Currently all our board supports DT. we are not using any driver
> > instantiated by board files.
> > I will remove the platform data for current patch and if it is require
> > then will add later with reasoning.
> > 
> > Hope this will be fine with Stephen also so that  this basic patch can
> > be included into tree soon.
> 
> I'm fine with it; it's just a change in policy that hadn't been
> communicated before.

Not really. For as long as I can remember there has been a strong bias
against unused code in the kernel. That goes for platform_data support
code as much as anything else.

What has been policy is that adding DT support must never break existing
non-DT support as long as non-DT booting is supported by a platform.

g.
