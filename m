Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0LKWw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 17:52:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0LKWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 17:52:24 -0500
Date: Sat, 11 Dec 2010 23:52:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Updated sysfs attribute documentation
In-Reply-To: <1292006614.2845.1.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1012112352080.15140@pobox.suse.cz>
References: <1292006614.2845.1.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Stefan Achatz wrote:

> Updated sysfs attribute documentation to reflect recent changes
> in driver design. The device specific attributes moved from the
> driver to the respective roccat char device.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
