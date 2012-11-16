Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab2KPKye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:54:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2KPKyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:54:32 -0500
Date: Fri, 16 Nov 2012 11:54:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.7-rc3: mouses stopped working
In-Reply-To: <20121116013405.GA2002@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.1211161153290.20577@pobox.suse.cz>
References: <20121115132849.GA4062@elf.ucw.cz> <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz> <20121115140736.GA2651@elf.ucw.cz> <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz> <20121116013405.GA2002@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Pavel Machek wrote:

> > If you have mouse that is buggy and periodically 
> > disconnecting/reconnecting itself, you need commit df0cfd6990347c, which 
> > went into 3.7-rc5 (it's a regression fix from -rc1).
> 
> I have -rc5 now, and still no mice for me.
> 
> root@amd:/tmp# uname -a
> Linux amd 3.7.0-rc5+ #236 SMP Thu Nov 15 20:07:26 CET 2012 i686 GNU/Linux
> root@amd:/tmp# cat /dev/input/mice
> cat: /dev/input/mice: No such device or address
> root@amd:/tmp# ls -al /dev/input/mice
> crw-rw---- 1 root root 13, 63 Apr 25  2010 /dev/input/mice
> root@amd:/tmp# 

Let's see whether this is /dev/input/mice issue or something else first.

Is anything coming out of corresponding /dev/input/eventX node?

And /dev/hidrawX?

Thanks,

-- 
Jiri Kosina
SUSE Labs
