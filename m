Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108Ab2JXSfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:35:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57282 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161041Ab2JXSfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:35:09 -0400
Date: Wed, 24 Oct 2012 14:35:05 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error w/ external USB drive
Message-ID: <20121024183505.GA6142@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <507C4BDA.20205@gmx.de>
 <20121019210723.GA4721@thunk.org>
 <5085923F.9050801@gmx.de>
 <20121024011128.GG28626@thunk.org>
 <5088260D.7080403@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5088260D.7080403@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 07:31:57PM +0200, Toralf Förster wrote:
> > Are you using any kind of special mount options on your usb stick?
> >
> nope

Thanks, we're trying to get a reliable repro of this failure, and so
every bit of data helps...  I've cc'ed you on the other thread, and if
you could try the second patch I sent out last night (and let me know
when/if the WARN_ON triggers), I'd really appreciate it.

Thanks again,

                                          - Ted
