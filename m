Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0FUNVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:21:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:47088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab0FUNVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:21:44 -0400
Date: Mon, 21 Jun 2010 15:21:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: removing obsolete kone_abi_version sysfs attr for
 roccat kone
In-Reply-To: <1276872145.2358.1.camel@localhost>
Message-ID: <alpine.LNX.2.00.1006211521130.13809@pobox.suse.cz>
References: <1276872145.2358.1.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010, Stefan Achatz wrote:

> The newest version of the accompanying userland tools cuts backward
> compatibility and uses libudev to find its devices superseding the
> quirky kone_abi_version sysfs attribute. Therefore it should be removed.

Thanks for explanation of the backwards compatibility (non-)issues with 
userspace tools in the other mail.

I have queued tha patch.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
