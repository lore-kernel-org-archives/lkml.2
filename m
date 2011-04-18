Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1DRNGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:06:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:52642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1DRNF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:05:58 -0400
Date: Mon, 18 Apr 2011 15:05:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: jwjstone@fastmail.fm, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: Allow to override LINUX_COMPILE_BY and
 LINUX_COMPILE_HOST macros
Message-ID: <20110418130556.GE9715@sepie.suse.cz>
References: <4D9B3AA4.5090402@fastmail.fm>
 <1302534289-17689-1-git-send-email-mmarek@suse.cz>
 <18001.1302578757@localhost>
 <4DA414F7.1090302@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA414F7.1090302@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 11:01:43AM +0200, Michal Marek wrote:
> On 12.4.2011 05:25, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 11 Apr 2011 17:04:49 +0200, Michal Marek said:
> >> Make it possible to override the user@host string displayed during boot
> >> and in /proc/version by the environment variables KBUILD_BUILD_USER and
> >> KBUILD_BUILD_HOST. 
> > 
> >> +
> >> +KBUILD_BUILD_TIMESTAMP
> > 
> > Changelog section doesn't match actual patch.  Other than that, I'm OK on this.
> 
> I changed it to
> 
>   Make it possible to override the user@host string displayed during boot
>   and in /proc/version by the environment variables KBUILD_BUILD_USER and
>   KBUILD_BUILD_HOST. Several distributions patch scripts/mkcompile_h to
>   achieve this, so let's provide an official way. Also, document the
>   KBUILD_BUILD_TIMESTAMP variable while at it.

Pushed to kbuild-2.6.git#kbuild.

Michal

