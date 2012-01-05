Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2AESJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:09:07 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:46393 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2AESJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:09:06 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jan 2012 13:09:05 EST
Date: Thu, 5 Jan 2012 19:02:19 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0.15
Message-ID: <20120105190219.38952ddf@neptune.home>
In-Reply-To: <20120103192936.GA1724@kroah.com>
References: <20120103192936.GA1724@kroah.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

For some reason the last few stable updates to 3.0 don't show up on
that main www.kernel.org page though the other stable updates do (for 3.1
and for 2.6.32).
The last 3.0 stable update showing up is 3.0.9 (but that's far from
being the most recent one), still the files for the following ones do
exist.

The upload-post-processing script probably does not like 3.0...

Thanks,
Bruno

On Tue, 03 January 2012 Greg KH <gregkh@suse.de> wrote:
> I'm announcing the release of the 3.0.14 kernel.
> 
> It contains a single bugfix for resume issues that were reported by a
> lot of people.  If you didn't have this problem, no need to upgrade.
> 
> The updated 3.0.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
