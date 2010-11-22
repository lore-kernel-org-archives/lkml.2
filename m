Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0KVX4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:56:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0KVX4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:56:53 -0500
Date: Mon, 22 Nov 2010 18:55:50 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.36.1
Message-ID: <20101122235549.GA31460@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
References: <20101122191831.GG4340@kroah.com>
 <AANLkTin2Wjfyo+pHBXR97bArS3=sSGmi5DCL8kapavSU@mail.gmail.com>
 <20101122213200.GC2881@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101122213200.GC2881@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:32:00PM -0800, Greg KH wrote:
 > On Mon, Nov 22, 2010 at 10:52:26PM +0200, Felipe Contreras wrote:
 > > On Mon, Nov 22, 2010 at 9:18 PM, Greg KH <gregkh@suse.de> wrote:
 > > > I'm announcing the release of the 2.6.36.1 kernel.
 > > >
 > > > All users of the 2.6.36 kernel series must upgrade.
 > > >
 > > > The updated 2.6.36.y git tree can be found at:
 > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
 > > > and can be browsed at the normal kernel.org git web browser:
 > > >        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=summary
 > > >
 > > > thanks,
 > > 
 > > This one is missing
 > > 0e7adbe ALSA: hda - Disable sticky PCM stream assignment for AD codecs
 > > 
 > > Otherwise sound doesn't work on AD codecs.
 > 
 > It will get into .2, thanks.
 > 
 > greg k-h

ed3aada1bf34c5a9e98af167f125f8a740fc726a also seems to be missing.

63bfd7384b119409685a17d5c58f0b56e5dc03da should be considered too.

	Dave
 
