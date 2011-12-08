Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1LHEB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:01:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57499 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab1LHEB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:01:56 -0500
Date: Thu, 8 Dec 2011 05:01:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208040150.GB24062@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-8-git-send-email-andi@firstfloor.org> <20111208010730.GB27892@redhat.com> <20111208011356.GA24062@one.firstfloor.org> <20111208012429.GC27892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208012429.GC27892@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 08:24:29PM -0500, Dave Jones wrote:
>  > AFAIK distros just load them all right?
> 
> In Fedora, we used to. In F16, we changed things so instead of a monstrous
> init script with nested if's and a whole bunch of hairy logic, we changed
> all the modules to be built-in's, and relied on the link-order in the cpufreq Makefile
> to satisfy the 'first to bind wins'.

This should continue working -- udev/modprobe will load them in link order

I'll keep it like it is now.

> Yes, ugly, but we didn't have this patchset ;-) 

I should have posted it earlier.

Just don't forget to change them back to =m once it goes in.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
