Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab0DHWvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:51:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab0DHWvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:51:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Vroon <tony@linx.net>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Date: Fri, 9 Apr 2010 00:54:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Michal Hocko <mhocko@suse.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20100401133923.GA4104@tiehlicka.suse.cz> <201004082243.18393.rjw@sisk.pl> <1270766263.5923.3.camel@localhost>
In-Reply-To: <1270766263.5923.3.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004090054.35949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, Tony Vroon wrote:
> Rafael,
> 
> I have the exact same "lid close = powering back on" regression on a
> Fujitsu-Siemens Lifebook S6420. Totally missed this thread before, but
> I'm glad that I'm not alone with this one.
> Happy to test any patches you may come up with; will an acpidump do for
> you or do you need additional data?

I need to figure out what actually happens and I'll need you to try a debug
patch, but it's not ready yet.

Rafael
