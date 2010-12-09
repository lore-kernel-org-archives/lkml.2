Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0LINw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:52:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:54436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab0LINw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:52:26 -0500
Date: Thu, 9 Dec 2010 14:52:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: rdunlap@xenotime.net, gregkh@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Aw: Re: [PATCH 0/5] HID: roccat: Achieve userspace notification
 on sysfs attribute creation
In-Reply-To: <2069123096.22885.1291902246397.JavaMail.ngmail@webmail07.arcor-online.net>
Message-ID: <alpine.LNX.2.00.1012091451400.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091430130.508@pobox.suse.cz> <1290801444.18750.161.camel@neuromancer> <2069123096.22885.1291902246397.JavaMail.ngmail@webmail07.arcor-online.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Stefan Achatz wrote:

> > I have applied the series, and removed the #pragma pack ugliness. Thanks,
> 

> Hello Jiri,
> Using my patch replacing the #pragma pack with the __packed macro would 
> have saved you some time: https://lkml.org/lkml/2010/11/27/14

Ah, missed that. Never mind.

> Just for the future: Whats better using the verbose version 
> __attribute__ ((__packed__)) or the macro __packed as I did?

I don't think I really care deeply here.

For some rationale why these shortcuts exist, please see commit 
82ddcb0405704.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
