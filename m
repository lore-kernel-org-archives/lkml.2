Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1HXCCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:02:44 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:56618 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab1HXCCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:02:39 -0400
Subject: Re: [PATCH v2 35/43] unicore32: Use set_current_blocked() and
 block_sigmask()
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <1314008796.19751.28.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-36-git-send-email-matt@console-pimps.org>
	 <1313979346.2905.27.camel@epip-laptop>
	 <1314008796.19751.28.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Wed, 24 Aug 2011 10:03:21 +0800
Message-ID: <1314151401.29738.35.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Matt,

For unicore32 bit,

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>


On Mon, 2011-08-22 at 11:26 +0100, Matt Fleming wrote:
> On Mon, 2011-08-22 at 10:15 +0800, Guan Xuetao wrote:
> > Hi, Matt
> > Could you add me (and other relevant people) to the patch series, or at
> > least the main patches in the series, since the separated patch is hard
> > to understand, and can't be tested.
> > 
> > For signal patches, I can only test it by booting up the system, running
> > some commands, and perhaps, running lmbench or ltp.
> > Is there any testsuite specified to signal part?
> > 
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > 
> > Thanks Matt.
> > Guan Xuetao
> 
> Hi Guan,
> 
> Unfortunately there are too many maintainers to add directly to the Cc
> list. However, I did reply to the first patch in the series (the only
> other one that matters for arch maintainers) and added yourself and
> linux-arch, so hopefully the rest of the arch maintainers will find it
> there. But just to be complete, the link to the patch is here,
> 
> 	https://lkml.org/lkml/2011/8/19/409
> 
> There isn't really a specific testsuite that I would recommend, though
> I'm pretty sure that LTP has some signal-related test cases. Booting up
> your system and running some commands (and perhaps interrupting them
> with Ctrl-C) should be good enough.
> 


