Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab0EVEFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 00:05:44 -0400
Received: from king.tilera.com ([72.1.168.226]:44819 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0EVEFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 00:05:43 -0400
Message-ID: <4BF757FF.6060100@tilera.com>
Date: Fri, 21 May 2010 21:05:19 -0700
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2010 04:05:42.0663 (UTC) FILETIME=[0BFC9970:01CAF964]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/2010 10:43 PM, Chris Metcalf wrote:
> At Tilera we have been running Linux 2.6.26 on our architecture for a
> while and distributing the sources to our customers.  We just sync'ed up
> our sources to 2.6.34 and would like to return it to the community more
> widely, so I'm hoping to take advantage of the merge window for 2.6.35
> to integrate support for our architecture.
>   

As an experiment, I've created a "git format-patch" output file for all
the remaining Tilera-specific changes; Alan took the
lowmem_page_address() change into -mm, so hopefully that will make it
into 2.6.35 as well.  I'm reluctant to post all the arch/tile contents
to LKML as a single 3 MB monster email, but you can just cut and paste
the following command to pull it into git:

wget http://www.tilera.com/scm/linux-2.6.34-arch-tile.patch | git am

In practice I could probably email it without causing grief to anyone's
mailer, but in the interests of saving disk and network bandwidth I'll
try this way.  There are no changes in this patch that affect any other
architecture.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


