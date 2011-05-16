Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1EPVRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:17:17 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44955 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1EPVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:17:15 -0400
From: Nix <nix@esperi.org.uk>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [BISECTED] 2.6.39rc: kobject-related reboot after RAID array initialization(?) post-QUEUE_FLAG_REENTER-removal
References: <8762pboc0j.fsf@spindle.srvr.nix>
	<20110516092113.60ed64d5@notabene.brown>
	<877h9reza9.fsf@spindle.srvr.nix> <4DD0FDE5.9000101@fusionio.com>
Emacs: a learning curve that you can use as a plumb line.
Date: Mon, 16 May 2011 22:17:05 +0100
In-Reply-To: <4DD0FDE5.9000101@fusionio.com> (Jens Axboe's message of "Mon, 16
	May 2011 12:35:17 +0200")
Message-ID: <878vu69wha.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2011, Jens Axboe verbalised:
> Out of curiousity, does this patch make a difference?

Yes. Crash cured, I can boot again.

Now I only have to worry about this ext4-quota-related panic on reboot,
completely uncaptured by netconsole (just as netconsole seems to fail to
capture almost every interesting piece of data these days).

I'll probably have to take a photo and transcribe it :(
