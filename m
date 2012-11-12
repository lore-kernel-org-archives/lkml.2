Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2KLMZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:25:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2KLMZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:25:50 -0500
Date: Mon, 12 Nov 2012 13:25:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: Rob Landley <rob@landley.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: roccat: Finishing cleanup and reset support
In-Reply-To: <1352611246.2463.214.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1211121323590.27271@pobox.suse.cz>
References: <1352611246.2463.214.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2012, Stefan Achatz wrote:

> This patchset finishes current cleanups and unifications.
> 
> Device reset is now implemented for all devices that support that
> feature.
> 
> A couple sysfs attributes have been deprecated and got replaced to unify
> the ABI as good as it gets with design decisions made in the past.
> 
> The next release of userland tools will only use these obsolete
> attributes as fallback. When that version is out, I will add all actual
> sysfs attributes from ABI/obsolete/sysfs-driver-hid-roccat-* to
> feature-removal-schedule.txt.

That file doesn't exist any more. Documenting in ABI/obsolete is the best 
we can get currently, I think. We are more-or-less safe to do that, as the 
interfaces have been in testing/ and the only documented user is your 
userspace program.

-- 
Jiri Kosina
SUSE Labs
