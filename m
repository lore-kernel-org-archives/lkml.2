Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0DITpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:45:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0DITpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:45:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #14792] Misdetection of the TV output
Date: Fri, 9 Apr 2010 21:48:39 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Adam Jackson" <ajax@redhat.com>, "Eric Anholt" <eric@anholt.net>,
       "Santi" <santi@agolina.net>, "Zhao Yakui" <yakui.zhao@intel.com>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera> <onZ81XwyNTD.A.MXE.uJmvLB@chimera> <20100408163916.67d054ef@virtuousgeek.org>
In-Reply-To: <20100408163916.67d054ef@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092148.39768.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, Jesse Barnes wrote:
> On Fri,  9 Apr 2010 00:54:29 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.32 and 2.6.33.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
> > Subject		: Misdetection of the TV output
> > Submitter	: Santi <santi@agolina.net>
> > Date		: 2009-12-12 13:28 (118 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/27dfaf4f5825a119305db1bc63bef30ed400e376
> > Handled-By	: Zhao Yakui <yakui.zhao@intel.com>
> 
> Looks like Yakui just pushed the fix for this one, so hopefully we'll
> be able to close it soon.

Great, thanks for the update.

Rafael
