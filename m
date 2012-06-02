Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab2FBUHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:07:24 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59270 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759749Ab2FBUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:07:23 -0400
Date: Sat, 2 Jun 2012 22:07:21 +0200
From: Andreas Mohr <andi@lisas.de>
To: Vishal Nandanwar <operational.people@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need help regarding parallel port interrupt in kernel 3.2
Message-ID: <20120602200721.GA2475@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKB833=F-Tkss-opb62eeF-zdGdXpG_Z=ONRazdGG1-gF1RidQ@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Problem here is, I am not getting interrupt or my interrupt handler is
> not executing. I wonder do we need to do any setting in BIOS for this
> interrupt? Or do we need to enable any flag during kernel compilation?

Hrmm, I might be mistaken, but probably only EPP (ECP?) are IRQ-based,
and plain-old SPP isn't?
If so, then that certainly would be a BIOS-side setup issue.
...which could be solved by making use of superiotool
for required configuration tasks instead (in many
cases at least).

HTH,

Andreas Mohr
