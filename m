Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002Ab0J2Uw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:52:58 -0400
Received: from 113901-app1.sourcehosting.net ([72.32.213.11]:56910 "EHLO
	mail1.sourcehosting.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758342Ab0J2Uwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:52:55 -0400
X-Greylist: delayed 1605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 16:52:55 EDT
MIME-Version: 1.0
Date: Fri, 29 Oct 2010 20:20:43 +0000
Message-Id: <eventum.4ker3k8ad.h886xz@secure.sourcehosting.net>
In-Reply-To: <eventum.4ker1nz9a.a4nuti@secure.sourcehosting.net>
From: "Sally Reich [via ASI support]" <support@audioscience.com>
Subject: [#3146] Re: ChaosBits.net - [PATCH] AudioScience HPI driver: Unsafe memory management when allocating control cache
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
X-Spam-Score: -98.6 (---------------------------------------------------)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

========================================================
This message and your reply sent to
Staff: eblennerhassett@audioscience.com, linux@audioscience.com, sreich@audioscience.com
Customers: jj@chaosbits.net, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, perex@perex.cz, tiwai@suse.de
========================================================
Hello Jesper,

A quick email to let you know that we received your email; our Linux developer should reply in the beginning of next week (I believe he is out of the office on Monday).

Regards,
~Sally

On Fri, 29 Oct 2010, 16:15:24 EDT, Sally Reich wrote:
>
> Hi,
> 
> I noticed that sound/pci/asihpi/hpicmn.c::hpi_alloc_control_cache() does 
> not check the return value from kmalloc(), which may fail.
> If kmalloc() fails we'll dereference a null pointer and things will go bad 
> fast.

<snip>

