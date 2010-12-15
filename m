Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab0LOCvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:51:45 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:22765 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0LOCvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:51:43 -0500
X-Loopcount0: from 143.166.82.43
Date: Tue, 14 Dec 2010 20:51:41 -0600
From: Matt Domsch <Matt_Domsch@Dell.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Narendra_K@Dell.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jordan_Hargrave@Dell.com,
        Charles_Rose@Dell.com
Subject: Re: [PATCH] Enable pci=bfsort by default on future Dell systems
Message-ID: <20101215025141.GA32334@auslistsprd01.us.dell.com>
References: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com> <20101214195445.GA31714@auslistsprd01.us.dell.com> <20101214201242.GC21909@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214201242.GC21909@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:12:43PM -0700, Matthew Wilcox wrote:
> Actually, how about we introduce a smaller patch that just makes
> bfsort the default for all machines with a BIOS date of 2011 or later?
> bfsort was what we always intended; it was unintentionally broken for,
> what, five years, and the only reason not to revert it was to not break
> setups that had come to rely on it.
> 
> So just make it the default for all future systems, no matter what
> manufacturer.

This approach would hit all systems that install a newly issued BIOS
after 2010, which could cause a change in behaviour for such systems.
I don't know how to get a "system manufactured" date or "system first
powered on" date generically (IIRC these might be exposed in
vendor-specific fields on Dell systems).

I'm not opposed, but it could result in a change of behavior for
still-maintained (as evidenced by newly issued BIOSes) systems.

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
