Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2IQP2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:28:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2IQP17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:27:59 -0400
Date: Mon, 17 Sep 2012 17:27:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: roccat: conditional blacklisting of Roccat
 modules
In-Reply-To: <1347890659.2398.1.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1209171727430.31149@pobox.suse.cz>
References: <1347890659.2398.1.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Stefan Achatz wrote:

> Roccat devices are standard compatible, specific drivers are only needed
> for extended functionality.
> If Roccat drivers are not configured, hid-generic binds these devices now.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

Applied, thanks Stefan.

-- 
Jiri Kosina
SUSE Labs
