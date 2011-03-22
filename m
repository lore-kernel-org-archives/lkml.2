Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1CVKoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:44:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1CVKoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:44:18 -0400
Date: Tue, 22 Mar 2011 11:44:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Ott <alan@signal11.us>, Jonathan Corbet <corbet@lwn.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v5 0/2] Documentation and Sample for hidraw
In-Reply-To: <20110321131732.8e8906a8.rdunlap@xenotime.net>
Message-ID: <alpine.LNX.2.00.1103221143560.19969@pobox.suse.cz>
References: <1297829209-10511-1-git-send-email-alan@signal11.us> <1300580985-10726-1-git-send-email-alan@signal11.us> <20110321131732.8e8906a8.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Randy Dunlap wrote:

> > Sorry I've been slack in getting v5 of this patch out. Because
> > it's been so long, I'll recap what happened last time:
> > 
> >  * Jon Corbet suggested that the example programs be moved into samples/ .
> >  * Randy Dunlap indicated his acked-by when this was done.
> > 
> > These patches add hidraw.txt to a new Documentation/hid/ directory.
> > 
> > It creates an example program which is now in samples/ with a Kconfig item.
> > 
> > The existing hiddev.txt has been moved from Documentation/usb/ to
> > Documentation/hid/
> 
> Jiri,
> 
> I suppose that you will merge these patches?
> or did you want me to do it?

Yeah, I am taking it through hid.git tree. Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
