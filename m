Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2ENIXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:23:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab2ENIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:23:52 -0400
Date: Mon, 14 May 2012 10:23:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] HID: Do not switch default values in EXPERT mode
In-Reply-To: <1336925230-2853-2-git-send-email-dh.herrmann@googlemail.com>
Message-ID: <alpine.LNX.2.00.1205141021530.15448@pobox.suse.cz>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com> <1336925230-2853-2-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012, David Herrmann wrote:

> Expert mode was designed to toggle visibility of options and not to
> change their behavior. If a user wants to tweak a single value and
> enables EXPERT mode to do this, he will have several unexpected
> side effects when other subsystems toggle their default values based
> on EXPERT mode. This makes EXPERT pretty useless.
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Please see

	d04b431e3d769fbbf26c4f4072002375c8cc4ed9
	b36299bcc0feae4c1bcff6a1561b8beb635e9c80
	
for some reasoning why this is done the way it's done.

Thanks,

-- 
Jiri Kosina
SUSE Labs
