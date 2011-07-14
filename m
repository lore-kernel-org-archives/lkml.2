Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1GNVoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:44:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1GNVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:44:00 -0400
Date: Thu, 14 Jul 2011 23:21:13 +0200
From: Greg KH <gregkh@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig:  Allow disabling of CONFIG_DEVPORT
Message-ID: <20110714212113.GA28639@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310675693-9204-1-git-send-email-mikew@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 01:34:52PM -0700, Mike Waychison wrote:
> It would be useful to build kernels with disabled support of /dev/port
> for systems where we do not want to allow an administrator to access IO
> ports directly.
> 
> To do so however, CONFIG_DEVPORT needs to be user-selectable.  Give this
> configuration option a name and help description.
> 
> Google-Bug-Id: 3177114

What is that field?  It's not something that I've ever seen before...

Please don't push internal fields like this to public patches, it only
causes confusion...

greg k-h
