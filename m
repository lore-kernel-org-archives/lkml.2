Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab0KPNOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:14:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:52361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab0KPNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:14:52 -0500
Date: Tue, 16 Nov 2010 14:14:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: kernel-janitors@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] backlight: constify backlight_ops
In-Reply-To: <902792.32985.qm@smtp148.mail.ukl.yahoo.com>
Message-ID: <alpine.LNX.2.00.1011161414230.7420@pobox.suse.cz>
References: <902792.32985.qm@smtp148.mail.ukl.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Lionel Debroux wrote:

> Patch against mainline.
> 
> One non-const struct instance constified by this patch was added after the
> the introduction of backlight_ops in checkpatch.pl's list of "should be const"
> structs (79404849e90a41ea2109bd0e2f7c7164b0c4ce73).

Added Ingo's Ack, and applied the whole series. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
