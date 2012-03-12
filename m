Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2CLPS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:18:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2CLPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:18:55 -0400
Date: Mon, 12 Mar 2012 10:18:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120312151852.GB12322@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
 <20120312145701.GA12322@ubuntu-macmini>
 <20120312150717.GA13211@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312150717.GA13211@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:07:17PM +0000, Matthew Garrett wrote:
> > We also have the problem of gmux_backlight versus acpi_video. On most
> > machines with a gmux the acpi_video backlight interface is present but
> > just doesn't work. This problem isn't just limited to Apples. I'm of the
> > opinion that we need a more generalized solution for arbitrating between
> > the backlight interfaces present on a given machine, but I haven't had a
> > chance to really think about what that would look like.
> 
> The ACPI code appears to be trapping into system management mode, so 
> figuring out what it's meant to do is going to be awkward. I think 
> having a hook in the ACPI video driver to deregister it in cases where 
> we know it doesn't work is legitimate, but since it presumably works 
> under Windows it'd be nice to figure out what's broken about it.

Why do you presume it works under Windows? Boot camp installs a pile of
drivers for Windows, one of those could be a driver for the backlight. I
don't know either way. But it's pretty clear that MacOS is using the
gmux for the backlight when it is present from the reverse engineering
work done by others.

Seth

