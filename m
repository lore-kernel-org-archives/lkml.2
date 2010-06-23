Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0FWUcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:32:31 -0400
Received: from eazy.amigager.de ([213.239.192.238]:43593 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0FWUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:32:30 -0400
Date: Wed, 23 Jun 2010 22:32:35 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Suspend hangs since 2.6.34
Message-ID: <20100623203234.GA20913@mac.home>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <20100621213224.GA5723@mac.home>
 <Pine.LNX.4.44L0.1006211828090.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006211828090.1687-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 18:31:57 -0400, Alan Stern wrote:

[...]

> Why does this look like a USB problem?  As far as I can tell, the bug 
> is that the system delays somewhere during the suspend procedure.  But 
> there's no reason to think the delay is connected with USB.

Breaking news: I just got the same hang when switching from X to the
console, so I gues that this bug has nothing to to with suspend, but
was just triggered by the switch to the console before suspend. I guess
I have to ask the intel-gfx folks.

Regards,
Tino
