Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2ISKv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:51:26 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35793 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2ISKu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:50:59 -0400
Date: Wed, 19 Sep 2012 12:50:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] plist: Make plist test announcements KERN_DEBUG
Message-ID: <20120919105053.GB4577@aftab.osrc.amd.com>
References: <1347446330-6378-1-git-send-email-bp@amd64.org>
 <1347455750.10751.36.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347455750.10751.36.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 09:15:50AM -0400, Steven Rostedt wrote:
> On Wed, 2012-09-12 at 12:38 +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > They show up in dmesg
> > 
> > [    4.041094] start plist test
> > [    4.045804] end plist test
> > 
> > without a lot of meaning so hide them behind debug loglevel.
> > 
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Anyone willing to pick this one up? Maybe akpm?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
