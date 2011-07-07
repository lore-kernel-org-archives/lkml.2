Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1GGGZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:25:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57556 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1GGGZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:25:38 -0400
Date: Wed, 6 Jul 2011 23:25:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: djkurtz@chromium.org, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 06/12] Input: synaptics - fuzz position if touchpad
 reports reduced filtering
Message-ID: <20110707062531.GE7658@core.coreip.homeip.net>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-7-git-send-email-djkurtz@chromium.org>
 <4E134EC7.7050001@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E134EC7.7050001@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:49:59AM -0700, Chase Douglas wrote:
> On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> > 
> > Synaptics touchpads indicate via a capability bit when they perform
> > reduced filtering on position data.
> > In such a case, use a non-zero fuzz value.
> > Fuzz = 8 was chosen empirically by observing the raw position data
> > reported by a clickpad indicating it had reduced filtering.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> Seems reasonable to me.
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Applied (folding necessary parts of the patch 1 into this one), thanks
Daniel.

-- 
Dmitry
