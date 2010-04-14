Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0DNBeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:34:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40758 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0DNBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:34:17 -0400
Date: Tue, 13 Apr 2010 19:33:34 -0600
From: Alex Chiang <achiang@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jbarnes@virtuousgeek.org
Subject: Re: WARNING: at fs/sysfs/dir.c:451 sysfs_add_one: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:01.0/slot'
Message-ID: <20100414013334.GA24240@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	gregkh@suse.de, jbarnes@virtuousgeek.org
References: <1271099285.9831.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271099285.9831.13.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris <eparis@redhat.com>:
> 
> I get one for 1.0, 1.1, 1.2, 2.0, 3.0, 4.0, 5.0.  Below I only show the
> example for 1.0.  Attached should be the full dmesg and config.  Please
> let me know about any ideas, tests, questions, or things I can do to
> help debug the spew....

These come from a patch I wrote, but unfortunately, I don't have
the time or hardware to properly debug them. :(

Jesse, can you please drop the slot sysfs symlink patch? I'll try
and pick them back up in the future.

Sorry for the spew.

/ac

