Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2JPOAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:00:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2JPOAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:00:00 -0400
Date: Tue, 16 Oct 2012 15:59:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yann Cantin <yann.cantin@laposte.net>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ebeam PATCH v2 1/2] hid: Blacklist eBeam devices
In-Reply-To: <20121010163747.GD19335@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1210161556450.14002@pobox.suse.cz>
References: <1349529287-23193-1-git-send-email-yann.cantin@laposte.net> <1349529287-23193-2-git-send-email-yann.cantin@laposte.net> <20121010163747.GD19335@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Dmitry Torokhov wrote:

> Jiri,
> 
> Are you OK with this change?

Yes, please take it through your tree together with the proper driver and 
add

	Acked-by: Jiri Kosina <jkosina@suse.cz>

to the HID blacklist additions.

Thanks,

-- 
Jiri Kosina
SUSE Labs
