Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0CSObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:31:13 -0400
Received: from mga10.intel.com ([192.55.52.92]:14190 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824Ab0CSObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:31:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,274,1267430400"; 
   d="scan'208";a="550511148"
Date: Fri, 19 Mar 2010 07:30:55 -0700
From: mark gross <mgross@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: 640E9920 <640e9920@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dwalker@codeaurora.org, tiwai@suse.de,
       bruce.w.allan@intel.com, aili@codeaurora.org,
       khilman@deeprootsystems.com
Subject: Re: [PATCH] PM_QOS updates for 2.6.34-rc1
Message-ID: <20100319143055.GA6124@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20100314003425.GA17812@mgross-acer>
 <20100314062637.GA12064@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314062637.GA12064@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 07:26:37AM +0100, Pavel Machek wrote:
> On Sat 2010-03-13 16:34:25, 640E9920 wrote:
> > The following patch series implements to following:
> > 1) pm_qos now uses a handle based implementation.  No more string
> > compares while walking lists.
> > 2) renames the exports to using more accurate names.
> > 3) updates kernel clients of pm_qos per this change
> > 4) added ascii interface to pmqos recognizing strings formatted in 10
> > charactor format "0x12345678"
> > 5) added new pm_qos class, "system_bus_throughput"
> > 
> > I would like to see this series make it into 2.6.34 if its not too late. 
> 
> I believe it is... -rc1 is past us.

crap.  I'll guess I'll redo them for next then.


 
> Also... the way the patches are structured... that will break bisect,
> no?

Um not sure, how would you recomend I structure them?

--mgross

> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
