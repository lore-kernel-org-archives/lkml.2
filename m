Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1FSBhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 21:37:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41565 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751156Ab1FSBhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 21:37:00 -0400
Date: Sat, 18 Jun 2011 21:36:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM: fix async resume following suspend failure
In-Reply-To: <201106182242.27814.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106182134290.3523-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Rafael J. Wysocki wrote:

> > Okay; I should have been more careful.  Thanks for fixing this up.
> 
> No problem. :-)
> 
> Appended is what I'm going to push to Linus.
> 
> Thanks,
> Rafael
> 
> ---
> From: Alan Stern <stern@rowland.harvard.edu>
> Subject: PM: Fix async resume following suspend failure

This looks fine.  It's a little hard to test; you have to create an 
artificial suspend failure.  Have you tried doing that?

Alan Stern

