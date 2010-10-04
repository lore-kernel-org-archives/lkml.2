Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0JDM6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:58:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:34648 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab0JDM6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:58:34 -0400
Date: Mon, 4 Oct 2010 14:58:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <greg@kroah.com>
Cc: Micki Balanga <micki@n-trig.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "jim.collar@eqware.net" <jim.collar@eqware.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
In-Reply-To: <20101004011949.GA23855@kroah.com>
Message-ID: <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
References: <6EF693376E00E2458E26FEC229232B128A8D39@Exchange2010-IL.n-trig.com> <20101004011949.GA23855@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, Greg KH wrote:

> > 
> 
> Can you please attach this in a non-base64 format so it can be properly
> reviewed, and then, applied if applicable?
> 
> Note, please run the patch through the scripts/checkpatch.pl tool first
> before sending it out, so we don't just say the same things it finds :)

As we already have HID driver for n-trig, could this whole thing perhaps 
be made part of it?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

