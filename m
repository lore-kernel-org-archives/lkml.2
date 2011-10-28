Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1J1Pqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:46:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab1J1Pqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:46:30 -0400
Date: Fri, 28 Oct 2011 17:46:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
In-Reply-To: <20111022102427.GB26724@schottelius.org>
Message-ID: <alpine.LNX.2.00.1110281745290.3541@pobox.suse.cz>
References: <20111017175906.GA3461@schottelius.org> <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz> <20111017214050.GA1408@schottelius.org> <20111019150122.GA6157@schottelius.org> <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz> <20111019210742.GA2432@schottelius.org>
 <20111022020205.GA26724@schottelius.org> <20111022102427.GB26724@schottelius.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Oct 2011, Nico Schottelius wrote:

> The missing bit to correct my previous patch: To which device IDs do the 
> devices named above match to? I.e. is USB_DEVICE_ID_APPLE_WELLSPRING6_* 
> the MacBook Air 4,2?

You need to check the USB IDs (lsusb will tell you) to see which quirk / 
translation table is getting used.

-- 
Jiri Kosina
SUSE Labs
