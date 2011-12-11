Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LKX15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:27:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1LKX1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:27:53 -0500
Date: Mon, 12 Dec 2011 00:27:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, rdunlap@xenotime.net,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
In-Reply-To: <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
Message-ID: <alpine.LNX.2.00.1112120027360.21970@pobox.suse.cz>
References: <4EDFD23D.4030703@xenotime.net> <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, David Herrmann wrote:

> We depend on memless force-feedback support, therefore correctly select the
> related config options.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Applied (with Cc to stable@ added). Thanks,

-- 
Jiri Kosina
SUSE Labs
