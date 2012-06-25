Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2FYNis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:38:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2FYNir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:38:47 -0400
Date: Mon, 25 Jun 2012 15:38:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fix the Kconfig option for generic device
 handling
In-Reply-To: <1340356390-4614-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1206251537190.18612@pobox.suse.cz>
References: <1340356390-4614-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Henrik Rydberg wrote:

> The generic HID driver is obviously not a special driver, so move
> it outside of the special drivers menu. Explain the usage and make
> the default follow the HID setting. This should simplify migration
> from older kernels.
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Jiri,
> 
> As pointed out by Jan Beulich, the generic hid driver Kconfig option
> is confusing. This patch ought to fix most of the concerns. For 3.5.

The change makes sense. I'd however propose to perhaps unify 
CONFIG_HID_SUPPORT and CONFIG_HID, while we are at it ... ?

Thanks,

-- 
Jiri Kosina
SUSE Labs
