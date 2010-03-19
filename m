Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0CSTrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:47:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0CSTq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:46:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mgross@linux.intel.com
Subject: Re: [PATCH] PM_QOS updates for 2.6.34-rc1
Date: Fri, 19 Mar 2010 20:49:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, 640E9920 <640e9920@gmail.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       aili@codeaurora.org, khilman@deeprootsystems.com
References: <20100314003425.GA17812@mgross-acer> <20100314062637.GA12064@elf.ucw.cz> <20100319143055.GA6124@linux.intel.com>
In-Reply-To: <20100319143055.GA6124@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003192049.34665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 March 2010, mark gross wrote:
> On Sun, Mar 14, 2010 at 07:26:37AM +0100, Pavel Machek wrote:
> > On Sat 2010-03-13 16:34:25, 640E9920 wrote:
> > > The following patch series implements to following:
> > > 1) pm_qos now uses a handle based implementation.  No more string
> > > compares while walking lists.
> > > 2) renames the exports to using more accurate names.
> > > 3) updates kernel clients of pm_qos per this change
> > > 4) added ascii interface to pmqos recognizing strings formatted in 10
> > > charactor format "0x12345678"
> > > 5) added new pm_qos class, "system_bus_throughput"
> > > 
> > > I would like to see this series make it into 2.6.34 if its not too late. 
> > 
> > I believe it is... -rc1 is past us.
> 
> crap.  I'll guess I'll redo them for next then.
> 
> 
>  
> > Also... the way the patches are structured... that will break bisect,
> > no?
> 
> Um not sure, how would you recomend I structure them?

Generally speaking, the kernel should build and should work correctly after
applying each consecutive patch in the series.

Rafael
