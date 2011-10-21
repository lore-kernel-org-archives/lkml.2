Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab1JUSWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:22:07 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:35634 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1JUSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:22:06 -0400
Date: Fri, 21 Oct 2011 20:22:04 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111021182204.GB26186@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
 <20111019210742.GA2432@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019210742.GA2432@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-g443452b x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

Nico Schottelius [Wed, Oct 19, 2011 at 11:07:42PM +0200]:
> [...] 
> I've tested my patches, all keys are mapped correctly now, xev output
> is attached. Please merge my patch from [0].

I've to correct myself, please do not merge currently:

The MacBook Air 3,1 indeed has such weired mappings, made a screenshot
of it today.

So I'll have to change my patch to use a different table on the MacBook
Air 4,2.

Will ping you, when I've updated the source.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
