Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0JOIW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:22:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0JOIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:22:55 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        agruen@suse.de, davem@davemloft.net
Subject: Re: Process to push changes to include/linux/types.h
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
	<20101014143723.ffea0d8c.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
Date: Fri, 15 Oct 2010 10:22:49 +0200
In-Reply-To: <alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr> (Jan
	Engelhardt's message of "Thu, 14 Oct 2010 23:50:34 +0200 (CEST)")
Message-ID: <878w1zc1ba.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@medozas.de> writes:

> I would be interested in knowing whether you - in whichever subsystems
> you happen to be active - would even need aligned_u64. Right now,
> the only users seem to be PPP and scsi_tgt besides Netfilter.

Using aligned_u64 is good practice to avoid problems with the 
32bit/64bit compat layer. I would recommend it to anyone 
adding a new user space interface passing a 64bit value.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
