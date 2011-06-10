Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1FJRYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:24:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59704 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1FJRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:23:59 -0400
Date: Fri, 10 Jun 2011 18:23:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110610172307.GA27630@srcf.ucam.org>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110528005640.9076c0b1.akpm@linux-foundation.org>
 <20110609185259.GA29287@linux.vnet.ibm.com>
 <BANLkTinxeeSby_+tta8EhzCg3VbD6+=g+g@mail.gmail.com>
 <20110610151121.GA2230@linux.vnet.ibm.com>
 <20110610155954.GA25774@srcf.ucam.org>
 <20110610165529.GC2230@linux.vnet.ibm.com>
 <20110610170535.GC25774@srcf.ucam.org>
 <20110610171939.GE2230@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610171939.GE2230@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 10:19:39AM -0700, Paul E. McKenney wrote:
> On Fri, Jun 10, 2011 at 06:05:35PM +0100, Matthew Garrett wrote:
> > I mean at the hardware level. As far as I know, the best we can do at 
> > the moment is to put an entire node into self refresh when the CPU hits 
> > package C6.
> 
> But this depends on the type of system and CPU family, right?  If you
> can say, which hardware are you thinking of?  (I am thinking of ARM.)

I haven't seen too many ARM servers with 256GB of RAM :) I'm mostly 
looking at this from an x86 perspective.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
