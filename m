Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0EXSoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:44:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0EXSoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:44:01 -0400
Date: Mon, 24 May 2010 11:42:54 -0700
From: Greg KH <gregkh@suse.de>
To: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
Cc: =?utf-8?B?0KLQuNC80L7RhNC10Lkg0KLRgNC+0YTQuNC80L7Qsg==?= 
	<tumoxep@gmail.com>,
       lieb@canonical.com, more.andres@gmail.com, forest@alittletooquiet.net,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: fix brace coding style issue in
 80211mgr.c This is a patch to the 80211mgr.c file that fixes up a brace
 warning found by the checkpatch.pl tool Signed-off-by: Timofey Trofimov
 <tumoxep@gmail.com>
Message-ID: <20100524184254.GD8291@suse.de>
References: <1274546574-8338-1-git-send-email-tumoxep@gmail.com>
 <20100522173510.GA26310@fujitsu>
 <AANLkTilS9UjF6jbsqtsZBlTkv_s4ayfu5GfW5_51tOzT@mail.gmail.com>
 <20100522235331.GA27828@fujitsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100522235331.GA27828@fujitsu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 04:53:32PM -0700, Charles Clément wrote:
> Hey,
> 
> On Sat, May 22, 2010 at 09:52:25PM +0400, Тимофей Трофимов wrote:
> > Hi, Charles. I understand what I did wrong and never will make this
> > mistake  mistake again. I really thought that I write this. Sorry.
> > P.S. This is my first patch. Does I need to resend it?
> 
> I think you should try to resend it, at least to get the subject line
> and body correct, you can try that by sending it only to yourself first.

It's ok, it's a common mistake combined with a bug in git-format-patch.
I can handle this just fine, don't worry about it.

thanks,

greg k-h
