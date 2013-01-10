Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3AJRpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:45:15 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:59739 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3AJRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:45:12 -0500
Date: Thu, 10 Jan 2013 09:44:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] input: keyboard: tegra: cleanups and DT supports
Message-ID: <20130110174456.GA2797@core.coreip.homeip.net>
References: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com>
 <50EAFD36.9070909@wwwdotorg.org>
 <50EE603B.7080702@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EE603B.7080702@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Thu, Jan 10, 2013 at 12:01:23PM +0530, Laxman Dewangan wrote:
> Hi Dmitry,
> 
> On Monday 07 January 2013 10:22 PM, Stephen Warren wrote:
> >On 01/06/2013 04:14 AM, Laxman Dewangan wrote:
> >>This patch series:
> >>  - fix build warning,
> >>  - use devm_* for allocation,
> >>  - make column/rows configuration through DT and
> >>  - remove the rarely used  key mapping table.
> >The series,
> >Reviewed-by: Stephen Warren <swarren@nvidia.com>
> >
> 
> If you are fine with this series then can it be apply please? I can
> handle if there is any comment on this series to close this.
> 

The patches are applied with minor edits to the 3rd and 4th (there was
no point in having a separate keymap setup function anymore).

Thanks.

-- 
Dmitry
