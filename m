Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0IAKmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:42:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:59668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0IAKmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:42:50 -0400
Date: Wed, 1 Sep 2010 12:42:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Kees Bakker <kees.bakker@xs4all.nl>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: add driver for Roccat Pyra mouse
In-Reply-To: <1283077818.2086.1.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1009011242320.26813@pobox.suse.cz>
References: <1283077818.2086.1.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Aug 2010, Stefan Achatz wrote:

> This patch add support for Pyra mobile gaming mouse from Roccat.
> It provides access to profiles, settings, actual settings etc.
> through sysfs attributes.
> This driver is conceptual similar to the existing Kone driver.

Applied, thank you Stefan.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
