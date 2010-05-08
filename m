Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0EHANN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:13:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab0EHANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:13:12 -0400
Date: Fri, 7 May 2010 17:10:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <201005080203.30634.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005071708010.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <201005080117.23760.rjw@sisk.pl> <alpine.LFD.2.00.1005071618410.901@i5.linux-foundation.org> <201005080203.30634.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 May 2010, Rafael J. Wysocki wrote:
> 
> To calrify, I think the approach in the Matthew's patch is correct, but since I have
> some bad experience with that particular thing, I prefer to make that change in
> 2.6.35 and then move on to drop the flag entirely.

Oh,yes. I'm not suggesting we do it late in the -rc cycle. 

I just don't think the DMI table is a good idea, so in the longer run I 
wan tto get rid of it, rather than have it grow (by quite a few entries, 
in this case).

There are valid reasons for DMI tables in many cases, but in this case I 
think the reason is simply that we do the wrong thing, so then we ended up 
with a DMI table to "fix" the wrong thing we do.

			Linus
