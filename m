Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2KGUsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:48:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2KGUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:48:31 -0500
Date: Wed, 7 Nov 2012 21:48:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
In-Reply-To: <CA+1xoqcBx83FmN=0Rt0NGfeWSj8AYVNeFNugDejR4_3=nVXAeA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1211072147040.27271@pobox.suse.cz>
References: <alpine.LNX.2.00.1210262112370.19184@pobox.suse.cz> <CA+1xoqcBx83FmN=0Rt0NGfeWSj8AYVNeFNugDejR4_3=nVXAeA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Sasha Levin wrote:

> Hi guys!
> 
> This is me complaining that I still see the spews that this pull
> request should fix, probably because this mail got lost.

You are seeing that on -next, right?

That's because a different version of the patchset has been pushed to 
Linus, but for-next branch in Jens' tree still contains the old patchset 
containing the faulty patch (which is never going upstream).

The fixed series is now in Linus' tree (as per -rc4), and I guess you are 
not having the problem there, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
