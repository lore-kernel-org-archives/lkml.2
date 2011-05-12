Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1ELRX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:23:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:40478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab1ELRX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:23:58 -0400
Date: Thu, 12 May 2011 10:20:26 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?St=E9phane?= Pajot <pajot.stephane@gmail.com>
Cc: arun.thomas@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix tabulation and over 80 chars
 issues in amplc_pci224.c This is a patch to the amplc_pci224.c file that
 fixes up tabulation style errors and over 80 chars warning found by the
 checkpatch.pl tool Signed-off-by: Steph
Message-ID: <20110512172026.GA14812@suse.de>
References: <BANLkTi=wa_OXF9c2XExScv-bNyR3Uu2aGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=wa_OXF9c2XExScv-bNyR3Uu2aGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 06:47:32PM +0200, Stéphane Pajot wrote:
> Hi Everybody,
> 
> Really sorry for the bug title with git send-email ... is there a way to avoid
> it ?

Yes, put a blank line in your changelog commit after the first line, and
git format-patch will do it correctly.

thanks,

greg k-h
