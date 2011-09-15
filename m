Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab1IOM5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:57:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1IOM5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:57:35 -0400
Date: Thu, 15 Sep 2011 14:57:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH][Resend] Remove unneeded version.h include from lib/
In-Reply-To: <alpine.LNX.2.00.1108012246470.31999@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1109151457260.13109@pobox.suse.cz>
References: <alpine.LNX.2.00.1108012246470.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Jesper Juhl wrote:

> This patch removes an unneeded include of linux/version.h from
> lib/dynamic_debug.c - identified by 'make versioncheck'.
> This is the only file in lib/ with this issue.

I have now applied the series. Thanks,

-- 
Jiri Kosina
SUSE Labs
