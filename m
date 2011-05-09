Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1EIPXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:23:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:51298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1EIPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:23:08 -0400
Date: Mon, 9 May 2011 08:23:21 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Stephane Pajot <pajot.stephane@gmail.com>, arun.thomas@gmail.com,
        ruben.smits@mech.kuleuven.be, abbotti@mev.co.uk,
        ext-andriy.shevchenko@nokia.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix brace coding style issue in
 jr3_pci.c This is a patch to the jr3_pci.c file that fixes up a brace
 warning found by the checkpatch.pl tool Signed-off-by: Stephane Pajot
 <pajot.stephane@gmail.com>
Message-ID: <20110509152321.GA29476@suse.de>
References: <1304949119-8250-1-git-send-email-pajot.stephane@gmail.com>
 <BANLkTik2=pezgunre5QC2HyADbuFP=H1zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik2=pezgunre5QC2HyADbuFP=H1zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 05:57:30PM +0300, Andy Shevchenko wrote:
> On Mon, May 9, 2011 at 4:51 PM, Stephane Pajot <pajot.stephane@gmail.com> wrote:
> 
> Please, split the subject and description with Signed-off-by lines.

It's an issue with git, I need to fix it one of these days...

Don't worry, I can take the original patch and edit it just fine,
thanks, I'll queue it up in a few days.

greg k-h
