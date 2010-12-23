Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0LWW5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:57:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54015 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751660Ab0LWW5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:57:53 -0500
Date: Thu, 23 Dec 2010 17:57:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Eric.Valette@Free.fr, lud <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
In-Reply-To: <20101223140226.04479f6a.rdunlap@xenotime.net>
Message-ID: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, Randy Dunlap wrote:

> [add linux-usb list]
> 
> 
> On Thu, 23 Dec 2010 10:55:38 +0100 Eric Valette wrote:
> 
> > I have the following messages:
> > 
> > Will now halt
> > hub:4-0:1.0: hub_port_status_failed (err 110)
> > 
> > repeated twice.
> > 
> > I did not attend the shutdown last evening and it was blocked there this 
> > morning. Retested and found same error.
> > 
> > Will open a regression bug (never have got this since 2.6.33).

That error message probably has no connection with whatever caused the 
system to hang up.

Alan Stern

