Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0IVJaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:30:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:36355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0IVJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:30:15 -0400
Date: Wed, 22 Sep 2010 11:30:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] hid: 3m: Adjust major / minor axes to scale
In-Reply-To: <4C992775.3000000@euromail.se>
Message-ID: <alpine.LNX.2.00.1009221129590.26813@pobox.suse.cz>
References: <4C992775.3000000@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Henrik Rydberg wrote:

> By visual inspection, the reported touch_major and touch_minor axes
> are a factor of two too large. Presumably the device actually reports
> the width_major and width_minor, which are generally about a factor of
> two larger than the touches themselves.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Just in case this patch got lost somewhere, here it is again.

Applied, thanks Henrik.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
