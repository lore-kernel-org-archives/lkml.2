Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0I0Bbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 21:31:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:38806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0I0Bbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 21:31:48 -0400
Date: Sun, 26 Sep 2010 18:31:52 -0700
From: Greg KH <gregkh@suse.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927013152.GA21139@suse.de>
References: <20100927003608.GA20395@kroah.com> <AANLkTikHtuXhMtjudLTUMPR7uL9eGGePUP93MqFLTfb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikHtuXhMtjudLTUMPR7uL9eGGePUP93MqFLTfb5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 04:00:51AM +0300, Felipe Contreras wrote:
> Hi,
> 
> On Mon, Sep 27, 2010 at 3:36 AM, Greg KH <gregkh@suse.de> wrote:
> > I'm announcing the release of the 2.6.35.6 kernel.
> >
> > All users of the 2.6.35 kernel series must upgrade.
> >
> > The updated 2.6.35.y git tree can be found at:
> > ?? ?? ?? ??git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
> > and can be browsed at the normal kernel.org git web browser:
> > ?? ?? ?? ??http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary
> 
> I usually do 'git fetch' to get new changes in all my repos, however,
> this one seems to be a bit different; there's no branch. Since there's
> no branch, 'git fetch' doesn't retrieve the tags.
> 
> Can you add a 'master' branch that points to the latest tag? That
> would make things easier for other people, specially the ones that
> just do 'git pull'.

I don't understand, this works for me this way, the master branch _is_
the latest version at all times.  Did you just need to wait a few
minutes to have the mirror catch up?

thanks,

greg k-h
