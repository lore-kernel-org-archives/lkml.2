Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1ATK34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:29:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:55771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1ATK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:29:53 -0500
Date: Thu, 20 Jan 2011 11:29:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/2] HID: roccat: Add support for Arvo, small bugfix and
 a question
In-Reply-To: <1294300829.5622.57.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1101201129020.29002@pobox.suse.cz>
References: <1294300829.5622.57.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Stefan Achatz wrote:

> This patchset adds support for the Roccat Arvo keyboard.
> The driver is similar to my other roccat drivers.

Applied, thanks for the driver, Stefan.

> I'm now finished implementing new device support and my next step would 
> be to abstract similarities to reduce code duplication.

That would be very welcome.

> Has the resulting file to be a module named like "roccat-common" that 
> has to be selected as depencendy in Kconfig or is there another 
> mechanism to hide this gratuitous decicion from the user?

Yes, I think this would be a reasonable implementation in this case.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
