Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750794Ab0JPIoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:44:15 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:43370 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0JPIoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:44:13 -0400
Date: Sat, 16 Oct 2010 10:44:07 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20101016084407.GC10844@excalibur.local>
References: <201010152300.34879.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010152300.34879.gene.heskett@gmail.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: Probably a repeat.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, 2010-10-15 at 23:00, Gene Heskett wrote:
> 
> Trying to build a 2.6.36-rc8, ends up here:
> 
>   Building modules, stage 2.
>   MODPOST 1248 modules
> ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
> ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
> 
> plus a couple section miss-matches, and of course it bailed out.  Next?

The commit directly after the -rc8 tag fixed this issue:
8fd01d6cfbf75465d84a4e533ed70c5f57b3ff51

regards
Stefan Schmidt
