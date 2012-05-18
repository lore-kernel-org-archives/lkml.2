Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946135Ab2EROTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413Ab2EROTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:19:52 -0400
Message-ID: <4FB65A6F.4090001@kernel.dk>
Date: Fri, 18 May 2012 16:19:27 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
References: <alpine.LNX.2.00.1205181524320.27407@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1205181524320.27407@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 03:28 PM, Jiri Kosina wrote:
> Jens,
> 
> please pull from 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream
> 
> to receive 3 patches for the floppy driver. The first one fixes a number 
> of races, which never exposed themselves on real floppy hardware, but are 
> triggering a lot on virtualized/emulated floppy drives. The second one 
> makes handling of O_EXCL on /dev/fd0 more consistent with other block 
> devices (and actually fixes a userspace-visible regression). The third one 
> adds myself as an unhappy maintainer, as discussed here: 
> https://lkml.org/lkml/2012/5/16/370
> 
> The 'upstream' branch is based on your 'for-3.5/drivers' branch.

Thanks Jiri, pulled in.

-- 
Jens Axboe

