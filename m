Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0GMMsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 08:48:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37669 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0GMMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 08:48:45 -0400
Date: Tue, 13 Jul 2010 14:48:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Branislav Gajdos <brianzee@gmail.com>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
Message-ID: <20100713124840.GA16427@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Branislav Gajdos <brianzee@gmail.com>,
	Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Branislav Gajdos <brianzee@gmail.com>
Date: Tue, Jul 13, 2010 at 01:44:38PM +0200

+Peter
+lkml

> I'm not sure if you're the right person to write to but my linux
> kernel (2.6.34.1) outputs this line while booting:
> 
> acerhdf: unknown (unsupported) BIOS version Acer/Aspire 3810T/V1.04,
> please report, aborting!

It doesn't look to me like this machine is a netbook with an Atom cpu
supported by this driver. Do as root:

dmidecode > dmi.log

and send me the dmi.log file please.

Thanks.

-- 
Regards/Gruss,
Boris.
