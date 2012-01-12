Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2ALAJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:09:09 -0500
Received: from unserver.de ([88.198.20.135]:50212 "EHLO unserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2ALAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:09:06 -0500
Date: Thu, 12 Jan 2012 00:08:48 +0000
From: Jan Steinhoff <mail@jan-steinhoff.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
Message-ID: <20120112000848.1c29f6a3@greyhound>
In-Reply-To: <20120110094334.GA7036@core.coreip.homeip.net>
References: <20120103194033.779cb829@greyhound>
	<201201041020.41795.oneukum@suse.de>
	<20120104094103.GA29069@core.coreip.homeip.net>
	<201201041056.20226.oneukum@suse.de>
	<20120104100553.GA29131@core.coreip.homeip.net>
	<20120105060138.704cfb16@greyhound>
	<20120105063611.GB31895@core.coreip.homeip.net>
	<20120105142257.7adbd098@guest>
	<20120110094334.GA7036@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012 01:43:34 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> The patch below seems to work well on my combo device (Lenovo keyboard
> with integrated touchpad/trackpoint). Could you please tell me if it
> works with your devices as well?

Yes, it works. Thanks a lot for the cleanup and improvement!

Just a last remark: The reconnects do not appear while the cPad is
suspended, so it is save to allow it to autosuspend. Can the autopm
calls be removed from probe and disconnect, and needs_remote_wakeup be
set in probe instead?
