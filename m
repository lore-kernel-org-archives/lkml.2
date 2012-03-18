Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2CRR1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 13:27:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51970 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2CRR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 13:27:11 -0400
Date: Sun, 18 Mar 2012 10:27:10 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, Colin Cross <ccross@android.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Andi <andi.shyti@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm/tegra: pcie: fix return value of function
Message-ID: <20120318172710.GA24110@quad.lixom.net>
References: <CAOesGMi0aqCjLsJ5wWXwFVQL2T8wtUuE14rFZ9h7NKHXcWAoqQ@mail.gmail.com>
 <1331617587-10714-1-git-send-email-mad_soft@inbox.ru>
 <4F5FA1BB.5050002@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5FA1BB.5050002@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:36:27PM -0600, Stephen Warren wrote:
> On 03/12/2012 11:46 PM, Dmitry Artamonow wrote:
> > In previous patch (arm/tegra: add timeout to PCIe PLL lock detection loop)
> > tegra_pcie_enable_controller() function type has been changed from
> > void to int, but the last return statement wasn't converted, so
> > function returns undefined value. Fix it.
> > 
> > Also while at it, address couple of minor concerns raised by reviewers:
> > use usleep_range for delay, and lower the value of timeout to 300ms
> > to be consistent with Nvidia Vibrante kernel.
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks, applied to for-3.4/cleanups-and-fixes


-Olof
