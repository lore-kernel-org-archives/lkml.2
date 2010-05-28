Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab0E1VMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:12:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38334 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0E1VMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:12:03 -0400
Date: Fri, 28 May 2010 22:11:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Angelo Arrifano <miknix@gmail.com>
Subject: Re: [RFC PATCH] Quickstart Button ACPI driver to serve PNP0C32
	ACPI devices
Message-ID: <20100528211156.GA3883@srcf.ucam.org>
References: <201005281940.09925.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005281940.09925.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 07:40:09PM +0200, Thomas Renninger wrote:

> The idea of these buttons is that they are undefined from BIOS/kernel
> point of view. Userspace has to map a functionality to them.
> Therefore the idea to modify the input event keycode via sysfs file.
> There should be 2 situations that perfectly are triggered via userspace:

They're logically buttons, so the right mechanism is for them to be 
configured via the standard keymap ioctls. There's already 
infrastructure for setting this via udev - see /lib/udev/keymaps on 
recent systems. That should let you avoid the need to 
unregister/reregister.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
