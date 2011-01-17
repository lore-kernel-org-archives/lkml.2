Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1AQMVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 07:21:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:53498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1AQMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 07:21:29 -0500
Date: Mon, 17 Jan 2011 13:21:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: hid-roccat-koneplus: potential NULL dereference
In-Reply-To: <1295258925-31288-1-git-send-email-segoon@openwall.com>
Message-ID: <alpine.LNX.2.00.1101171321140.26685@pobox.suse.cz>
References: <1295258925-31288-1-git-send-email-segoon@openwall.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011, Vasiliy Kulikov wrote:

> kmalloc() may fail, if so return -ENOMEM.
> Also koneplus_init_koneplus_device_struct() should check return code
> of koneplus_get_startup_profile() and propagate its return code.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks Vasiliy.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
