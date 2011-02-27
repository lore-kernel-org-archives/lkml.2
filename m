Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1B0So4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 13:44:56 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33091 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1B0Soz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 13:44:55 -0500
Date: Sun, 27 Feb 2011 19:44:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Add ``cloneconfig'' target
Message-ID: <20110227184453.GA28732@merkur.ravnborg.org>
References: <4D671556.80607@suse.com> <20110225060706.GA12723@merkur.ravnborg.org> <AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com> <20110226221838.GA24028@merkur.ravnborg.org> <AANLkTi=+AU3gJJOov8R1fNcZVE7iNpbTLDuMB5PHUk8s@mail.gmail.com> <AANLkTikigj1rDHrUaySHAYrW=GPPezbmcaDfx78AqE1_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikigj1rDHrUaySHAYrW=GPPezbmcaDfx78AqE1_@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 06:28:43PM -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Sat, Feb 26, 2011 at 6:03 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >> The fact that the configuration is gzipped does not warrant
> >> a new option to deal with this that almost duplicate the
> >> existing functionality.
> >>
> > agree.
> >
> Let me precise, as there may be confusion. I agree about the new
> target issue, but definitively think this kconfig "option" (more a
> hack, which required a special option within kconfig) should be
> handled by Kbuild, not Kconfig, ie. I'd discard "option
> defconfig_list". File decompression (and eventually which config to
> pick) should be done prior to the invocation of Kconfig.

If you can come up with something simpler and better than
what we have today then fine.
Simplifying kconfgi would be good.

But at least barebox uses defconfig_list - an maybe others.
We need to consider non-kernel users too.

	Sam
