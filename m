Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab0GJKIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:08:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40537 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0GJKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:08:12 -0400
Message-ID: <4C384620.8040808@kernel.org>
Date: Sat, 10 Jul 2010 12:06:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org> <4C25CC18.2070507@kernel.org> <4C2DFAB0.3020703@kernel.org>
In-Reply-To: <4C2DFAB0.3020703@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 10 Jul 2010 10:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 04:41 PM, Tejun Heo wrote:
> Hello, Jeff.
> 
> So, something like the following.  This should be applied on top of
> the two previous libata patches.  The amount of code in the hot path
> is very small.  Compared to the cpu actually taking an interrupt and
> accessing hardware, it should be negligible, and this will give us
> working and acceptably performing systems in the presence of most
> types of IRQ problems.

Ping.

-- 
tejun
