Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab1KVW17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1KVW16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:27:58 -0500
Date: Tue, 22 Nov 2011 23:27:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] sound: Kconfig: drop unknown symbol
 ARCH_CLPS7500
In-Reply-To: <1321982633.1753.12.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111222327080.28728@pobox.suse.cz>
References: <1321963622.18752.1.camel@x61.thuisdomein>  <alpine.LNX.2.00.1111221813320.28728@pobox.suse.cz> <1321982633.1753.12.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Paul Bolle wrote:

> > While you are at it, there is one more reference to this symbol (in 
> > comments) in drivers/net/ethernet/cirrus/cs89x0.c
> 
> Yes, in a changelog entry which I didn't want to touch yet. Should
> changelogs, like that one, be dropped as soon as we're doing something
> related? 

Gah, I have missed the fact that's in changelog, you are right.

-- 
Jiri Kosina
SUSE Labs
