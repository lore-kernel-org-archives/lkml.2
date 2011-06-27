Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1F0SMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:12:34 -0400
Received: from mail.candelatech.com ([208.74.158.172]:46742 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1F0SM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:12:29 -0400
Message-ID: <4E08C80B.9070602@candelatech.com>
Date: Mon, 27 Jun 2011 11:12:27 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Question on debugging use-after-free memory issues.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a case where deleted memory is being passed into an RPC
callback.  I enabled SLUB memory poisoning and verified that the
data pointed to has 0x6b...6b value.

Unfortunately, the rpc code is a giant maze of callbacks and I'm
having a difficult time figuring out where this data could be erroneously
deleted at.

So first question:

Given a pointer to memory, and with SLUB memory debuging on (and/or other
debugging options if applicable), is there a way to get any info about where
the memory was last deleted?

Second:  Any other suggestions for how to go about debugging this?

I hit this problem under load after multiple hours, so just adding printks
in random places may not be feasible...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

