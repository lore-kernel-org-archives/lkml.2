Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1G2UYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:24:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34256 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1G2UYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:24:50 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 22:27:36 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
References: <201107251043.19932.oneukum@suse.de> <20110729195430.GB1720@ucw.cz>
In-Reply-To: <20110729195430.GB1720@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292227.36424.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. Juli 2011, 21:54:30 schrieb Pavel Machek:
> On Mon 2011-07-25 10:43:19, Oliver Neukum wrote:
> > Hi Rafael,
> > 
> > I had a problem with the kernel stopping the machine forever because I got an
> > oops while tasks were frozen. It seems to me that we should thaw when this
> > happens. How about this approach?
> 
> Danger, Will Robinson. You must not write to the filesystems after
> hibernation started. By thawing, you may do just that.
> 
> It should be safe to thaw as long as final suspend signature is not
> on disk and will not be written there.

Yes. But this applies only if I use kernel-space hibernation, doesn't it?
So I need a second flag for the signature being written. Any other problem?

	Regards
		Oliver
