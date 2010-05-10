Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0EJVAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:00:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38090 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0EJVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:00:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH v21 015/100] cgroup freezer: Update stale locking comments
Date: Mon, 10 May 2010 23:01:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Cedric Le Goater <legoater@free.fr>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-pm@lists.linux-foundation.org
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <201005062140.19821.rjw@sisk.pl> <4BE333B0.1010003@cs.columbia.edu>
In-Reply-To: <4BE333B0.1010003@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005102301.45729.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Oren Laadan wrote:
> 
> On 05/06/2010 03:40 PM, Rafael J. Wysocki wrote:
> > On Saturday 01 May 2010, Oren Laadan wrote:
> >> From: Matt Helsley <matthltc@us.ibm.com>
> >>
> >> Update stale comments regarding locking order and add a little more detail
> >> so it's easier to follow the locking between the cgroup freezer and the
> >> power management freezer code.
> > 
> > I guess these three patches are for me.
> > 
> > Do you want me to handle them?
> 
> Yes, please, that would be great.

However, patches 16 and 17 seem to depend on checkpoint/restart and don't
appear to be margeable at this point.  Is this correct?

Rafael
