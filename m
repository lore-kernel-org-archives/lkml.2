Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2JXUqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:46:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:60473 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2JXUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:46:00 -0400
From: Nix <nix@esperi.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>, Peng Tao <bergwolf@gmail.com>,
        Trond.Myklebust@netapp.com, gregkh@linuxfoundation.org,
        Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
Emacs: no job too big... no job.
Date: Wed, 24 Oct 2012 21:45:47 +0100
In-Reply-To: <878vavveee.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Wed, 24 Oct 2012 20:49:45 +0100")
Message-ID: <878vavtx8k.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-sonic.net-Metrics: spindle 1117; Body=10 Fuz1=10 Fuz2=10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Oct 2012, nix@esperi.org.uk spake thusly:
> So, the net effect of this is that normally I get no journal recovery on
> anything at all -- but sometimes, if umounting takes longer than a few
> seconds, I reboot with not everything unmounted, and journal recovery
> kicks in on reboot.

It occurs to me that it is possible that this bug hits only those
filesystems for which a umount has started but been unable to complete.
If so, this is a relatively rare and unimportant bug which probably hits
only me and users of slow removable filesystems in the whole world...

-- 
NULL && (void)
