Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1KOT0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:26:32 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:47546 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab1KOT0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:26:15 -0500
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <4EC2B1F7.6090108@suse.cz>
References: <1321362602.20271.192.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
	 <1321371462.20271.201.camel@x61.thuisdomein>  <4EC2B1F7.6090108@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 20:26:14 +0100
Message-ID: <1321385174.20271.222.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 19:39 +0100, Michal Marek wrote:
> > But, I do have a naive question: are defconfigs meant to be drop in
> > replacements for .config files or is one supposed to first feed them to
> > the config tools to generate an up to date .config?
> 
> defconfig files are used as input of the conf program.
> 
> > Since, if one is
> > supposed to feed them to the config tools first it doesn't matter
> > whether the (outdated) macros are still used somewhere in the code,
> > doesn't it? The config tools will simply drop all macros they can't
> > match with Kconfig symbols. (Or don't they? Michal?)
> 
> Yes, they will not appear in the .config.

So the fact that a few of these macros are still currently used in the
code shouldn't bother us. The maintainers of that code have no reason to
complain about dropping those macros from the various defconfig files,
because that removal doesn't actually matter. Correct?


Paul Bolle

