Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1KOPiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:38:11 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:55399 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab1KOPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:38:10 -0500
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
References: <1321362602.20271.192.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 16:37:42 +0100
Message-ID: <1321371462.20271.201.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 14:14 +0100, Jiri Kosina wrote:
> I am fine taking those through trivial.git and handling the fallout.

Great.

> The only ones I'd have objections to taking immediately are those which are 
> actually still referenced somewhere in the code.
> For those, either taking them through appropriate maintainers, or having 
> their Acked-by would be required.

I don't mind. That shouldn't be a lot of extra work for me. 

But, I do have a naive question: are defconfigs meant to be drop in
replacements for .config files or is one supposed to first feed them to
the config tools to generate an up to date .config? Since, if one is
supposed to feed them to the config tools first it doesn't matter
whether the (outdated) macros are still used somewhere in the code,
doesn't it? The config tools will simply drop all macros they can't
match with Kconfig symbols. (Or don't they? Michal?)


Paul Bolle

