Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab0GWNMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:12:31 -0400
Received: from mail.tpi.com ([70.99.223.143]:2173 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab0GWNMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:12:30 -0400
Message-ID: <4C4994FB.9090205@mail.tpi.com>
Date: Fri, 23 Jul 2010 15:11:23 +0200
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
Organization: Canonical, Ltd
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Wilson <"email addresshidden"@ogre.sisk.pl>,
        Kees Cook <kees@outflux.net>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.9fB.v3XSMB@chimera>
In-Reply-To: <tneGvaw1wLL.A.9fB.v3XSMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 01:47 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
> Subject		: [Q35 bisected] hang at init of i915 driver
> Submitter	: Kees Cook<kees@outflux.net>
> Date		: 2010-06-25 18:20 (29 days old)
> First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
> Handled-By	: Tim Gardner<tim.gardner@canonical.com>
> Patch		: https://patchwork.kernel.org/patch/111130/
>
>

There is a patch attached to the BZ report that has been ack'd by a 
couple of testers as well as by the original committer. I've been told 
that it should go through Eric Anholt instead of Dave Arlie, but Eric 
has yet to respond.

Acked-by and Tested-by included in this thread: 
http://lkml.org/lkml/2010/7/21/278

rtg
-- 
Tim Gardner tim.gardner@canonical.com
