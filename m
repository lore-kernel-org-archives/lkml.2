Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2BQUoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:44:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2BQUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:44:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] PM / QoS: unconditionally build the feature
Date: Fri, 17 Feb 2012 21:48:32 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jean Pihet <j-pihet@ti.com>, linux-kernel@vger.kernel.org,
        Mark Gross <markgross@thegnar.org>
References: <1328603646-2714-2-git-send-email-j-pihet@ti.com> <201202131641.10535.rjw@sisk.pl> <20120217192724.GC2707@elf.ucw.cz>
In-Reply-To: <20120217192724.GC2707@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202172148.32168.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 17, 2012, Pavel Machek wrote:
> On Mon 2012-02-13 16:41:10, Rafael J. Wysocki wrote:
> > On Monday, February 13, 2012, Jean Pihet wrote:
> > > The PM QoS feature depends on CONFIG_PM which depends on
> > > PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
> > > not having these CONFIGs.
> > > 
> > > This patch allows the feature in all cases.
> > > 
> > > Signed-off-by: Jean Pihet <j-pihet@ti.com>
> > > Reported-by: Venkatesh Pallipadi <venki@google.com>
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Cc: Mark Gross <markgross@thegnar.org>
> > 
> > Applied, but I modified the changelog (please have a look at the
> > linux-pm/pm-qos branch for details).
> 
> Is it good idea? For servers, power management / QoS is not
> neccessary... 

Yes, it is.  They surely use CPUidle.

Thanks,
Rafael
