Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0DOKnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:43:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:34924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0DOKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:43:11 -0400
Date: Thu, 15 Apr 2010 12:43:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
 y
In-Reply-To: <20100415063626.GG21894@myhost.felk.cvut.cz>
Message-ID: <alpine.LRH.2.00.1004151233010.28179@twin.jikos.cz>
References: <20100413025228.GC10860@localhost.localdomain> <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com> <20100415063626.GG21894@myhost.felk.cvut.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Michal Svoboda wrote:

> > Have you ever successfully attack by this way? If CONFIG_STRICT_DEVMEM
> > is not set, the /dev/mem access is filtered in pat code.
> 
> If that option doesn't add any protection, what's it good for?

Access to /dev/mem being filtered in PAT obviously applies only to x86. 

Architectures which don't do such filtering in their respective 
phys_mem_access_prot_allowed() still need this option.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
