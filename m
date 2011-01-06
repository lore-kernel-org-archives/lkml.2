Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1AFKcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:32:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:37025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1AFKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:32:23 -0500
Date: Thu, 6 Jan 2011 11:32:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "James T. Dickson" <james.dickson@jtdata.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
In-Reply-To: <5171053.20.1294278131468.JavaMail.root@butch.jtdata.net>
Message-ID: <alpine.LNX.2.00.1101061131460.26685@pobox.suse.cz>
References: <5171053.20.1294278131468.JavaMail.root@butch.jtdata.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011, James T. Dickson wrote:

> I have applied this patch and can report that it has fixed the problem Ubuntu 10.10. 

Thanks a lot for reporting back.

> However, the mouse freezes when a coming out of suspend and the system 
> will not shutdown.

And that doesn't happen with the touchpad being only in PS/2 mode, right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
