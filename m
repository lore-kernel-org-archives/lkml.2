Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0FAICr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:02:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:44719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0FAICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:02:45 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [regression] Please add bug 15788 and 15969, usb sound / radeon kms broken after snapshot cycle
Date: Tue, 1 Jun 2010 10:02:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <201005312215.17793.Martin@lichtvoll.de>
In-Reply-To: <201005312215.17793.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011002.59191.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. Mai 2010 22:15:04 schrieb Martin Steigerwald:
> 
> Hi Rafael,
> 
> please add
> 
> Bug 15788 -  external usb sound card doesn't work after resume
> https://bugzilla.kernel.org/show_bug.cgi?id=15788

Does it show up in /proc/asound/cards ?

	Regards
		Oliver
