Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0LINyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:54:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:54547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0LINyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:54:52 -0500
Date: Thu, 9 Dec 2010 14:54:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add and use hid_<level>: dev_<level> equivalents
In-Reply-To: <1290549269.28824.43.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <1290497701.28824.6.camel@Joe-Laptop>  <alpine.LNX.2.00.1011231336420.18801@pobox.suse.cz> <1290549269.28824.43.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, Joe Perches wrote:

> Neaten current uses of dev_<level> by adding and using
> hid specific hid_<level> macros.
> 
> Convert existing uses of dev_<level> uses to hid_<level>.
> Convert hid-pidff printk to use hid_<level>.
> 
> Remove err_hid and use hid_err instead.
> 
> Add missing newlines to logging messages where necessary.
> Coalesce format strings.
> 
> Add and use pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> Other miscellaneous changes:
> 
> Convert vmalloc/memset to vzalloc
> Remove unnecessary __inline_ from some static functions.
> Add const struct hid_device * as argument to some functions
> so hid_<level> can be used as appropriate.
> Remove unnecessary multiplies in inner loops, use += instead.

Hi Joe,

even though these are purely cleanup changes, I'd like to have them 
separated (or at least have more appropriate Subject: line for the 
commit).

Would you care to split that up?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
