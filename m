Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1FMKwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:52:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1FMKwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:52:17 -0400
Date: Mon, 13 Jun 2011 12:52:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Changed plain Kconfig menu to submenu for
 roccat devices.
In-Reply-To: <1306936450.2486.6.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1106131252030.22872@pobox.suse.cz>
References: <1306936450.2486.6.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Stefan Achatz wrote:

> As module roccat is needed by all devices, it's the toplevel
> menu entry with all devices dependent.

I like this cleanup. Applied, thanks Stefan.

-- 
Jiri Kosina
SUSE Labs
