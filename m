Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0JUPGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:06:01 -0400
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:34502 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab0JUPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:05:59 -0400
Message-ID: <4CC056CA.9060903@genband.com>
Date: Thu, 21 Oct 2010 09:05:46 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] problems with "ip xfrm" on 32-bit userspace with 64-bit
 kernel
References: <4CBF78B6.90002@genband.com> <20101021075056.GE15247@Chamillionaire.breakpoint.cc>
In-Reply-To: <20101021075056.GE15247@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2010 15:05:48.0457 (UTC) FILETIME=[71AB2990:01CB7131]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17716.007
X-TM-AS-Result: No--13.462200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 01:50 AM, Florian Westphal wrote:
> Chris Friesen <chris.friesen@genband.com> wrote:
>> We've run into a 32/64 compatibility problem with iproute2.  The "ip
>> xfrm monitor acquire" command doesn't work properly due to struct size
>> mismatches between kernel and userspace.
> 
> Yes.  See archives for 'xfrm: add x86 CONFIG_COMPAT support'
> (http://marc.info/?t=127050655600003&r=1&w=2)
> 
> for a discussion on why the patch set to fix this was rejected.

Interesting discussion.  Kind of sucks for people trying to use it though.

How do distros resolve this?  Do they build iproute2 as a 64-bit package
or something?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
