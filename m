Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1GGGaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:30:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53370 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1GGGaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:30:22 -0400
Date: Wed, 6 Jul 2011 23:30:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: djkurtz@chromium.org
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 01/12] Input: synaptics - cleanup 0x0c query documentation
Message-ID: <20110707063016.GG7658@core.coreip.homeip.net>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309324042-22943-2-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 01:07:11PM +0800, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Convert some spaces to tabs.
> Reorder defines to match bit ordering.
> Add defines for all bits.

I'd prefer if we added defines for bits we are actually using, so I am
going to drop this patch (sans the bits I folded into fuzz patch).

Thanks.

-- 
Dmitry
