Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0LOU6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:58:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39968 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752158Ab0LOU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:58:39 -0500
Date: Wed, 15 Dec 2010 15:58:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 4/4] PM: Permit registrarion of parentless devices
 during system suspend
In-Reply-To: <201012150134.27858.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012151546320.2171-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Rafael J. Wysocki wrote:

> > You could clear in_suspend at the start of device_resume.
> 
> The patch below (replacing [3/4]) does that (the second clearing is for
> devices whose ->suspend() methods have not been called, which can happen if
> there's a suspend error).
> 
> I hope the USB part is still valid?

It is.  Although now that I look at it, the third USB test is (and has
always been) totally wrong.  It should be removed completely.  I'll do 
that separately; for now your update won't affect the way it works.

Alan Stern

