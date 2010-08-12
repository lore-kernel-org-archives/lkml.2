Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab0HLTd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:33:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35139 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HLTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:33:54 -0400
Date: Thu, 12 Aug 2010 21:33:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [PATCH 0/2] kconfig: fixes for savedefconfig
Message-ID: <20100812193353.GB32373@merkur.ravnborg.org>
References: <20100812071023.GA11148@merkur.ravnborg.org> <4C63BB09.80609@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C63BB09.80609@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 11:12:41AM +0200, Michal Marek wrote:
> On 12.8.2010 09:10, Sam Ravnborg wrote:
> > While tranislating all remaining defconfigs in
> > the kernel to the minimal format I encountered
> > an issue where the resulting .config was not
> > equal to the original.
> > 
> > This was tracked down to missing info in the saved defconfig file.
> > 
> > Arve reported another problem with tristate choice that was
> > reproduceable with a small config sample.
> > 
> > The followng patches fixes both issues.
> > There is no outstanding issue with respect to savedefconfig.
> 
> Applied, thanks a lot Sam!

I would like to see these patches hit mainline soonish.
I have a small shellscript that will convert remaining defconfigs to
the minimal format and like it to be run just before after -rc1.
But these patches is needed before I can ask Linus to run the script.

	Sam
