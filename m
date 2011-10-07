Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1JGPKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1JGPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:10:09 -0400
Date: Fri, 7 Oct 2011 11:10:04 -0400
From: Dave Jones <davej@redhat.com>
To: Frank Mehnert <frank.mehnert@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111007151003.GA26358@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frank Mehnert <frank.mehnert@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andy Hall <andy.hall@oracle.com>
References: <20111006190526.GA13883@redhat.com>
 <201110071640.53827.frank.mehnert@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110071640.53827.frank.mehnert@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:40:53PM +0200, Frank Mehnert wrote:
 
 > I can understand that you would rather ignore bug reports from external
 > kernel modules. On the other hand I don't like the TAINT_CRAP flag as
 > you can probably imagine.
 > 
 > Why not just mark external modules like Bastian Blank suggested? I can
 > assure that we will not try circumvent a TAINT_OOT_MODULE flag.

Sure. The exact mechanism used doesn't matter to me.

 > Please also note that we always have good relations to the open source
 > community so feel free to point me an archive where all these kernel
 > panic reports arrive which you've got.

Search through the fedora kernel bugs at bugzilla.redhat.com for 'vboxdrv'
or 'virtual box' (note to search for closed bugs as well as open ones).

 > We fixed some bugs in our kernel
 > modules in the past and it is even possible that some of the current
 > bug reports are from older versions of VirtualBox which might have been
 > fixed in the meantime.
 > 
 > And of course, helpful and constructive critism is always appreciated.

If you'd like to be cc'd on those reports, I can add you to the bugs
when we go through them if you create a bugzilla account. 

	Dave

