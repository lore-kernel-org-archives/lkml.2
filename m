Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0LAPyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:54:45 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:64387 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025Ab0LAPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:54:44 -0500
X-Greylist: delayed 83092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 10:54:44 EST
Date: Wed, 1 Dec 2010 16:54:41 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Harry Nak <harrynak@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: timer.c - high load avarage with idle cpu
Message-ID: <20101201155441.GA22342@brouette>
References: <AANLkTimDVNfTavhLD9=yD=EYWASoRZQy9FCHkiLNgYFJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDVNfTavhLD9=yD=EYWASoRZQy9FCHkiLNgYFJ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> [...]
> My solution is to postpone the call to run_local_timers() until
> scheduler_tick() has been called.

> Could anybody confirm my theory and is it possible that my solution
> breaks anything?

Your problem might be related to this thread:
https://lkml.org/lkml/2010/9/29/51

-- 
Damien
