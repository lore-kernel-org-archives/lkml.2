Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab2GDHkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:40:31 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:47637 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2GDHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:40:28 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnNKAMry809V5qg+PGdsb2JhbABEihmtBhkBAQEBHgMWDSeCGAEBBTocIxAIAxguFCUKGhOID7ppFIslhVdgA5U2hWaDQYk+
X-IronPort-AV: E=Sophos;i="4.77,521,1336341600"; 
   d="scan'208";a="152090264"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 4 Jul 2012 09:40:49 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH 1/2 v2] HID: magicmouse: Removing report_touches switch
Message-ID: <20120704074049.GA380@polaris.bitmath.org>
References: <1341341621-15560-1-git-send-email-miletus@chromium.org>
 <4FF35597.7020408@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF35597.7020408@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:27:03PM -0700, Chase Douglas wrote:
> On 07/03/2012 11:53 AM, Yufeng Shen wrote:
> >Remove the report_touches switch as it is not so useful to turn
> >off reporting touch events for a touch device. Let the userspace
> >to do the filtering if the turning off is needed.
> >
> >V2: Remove report_touches as suggeted by Chase Douglas
> >
> >Signed-off-by: Yufeng Shen <miletus@chromium.org>
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Hi Chase,

While testing the new patches, I noticed that only four fingers would
come through; a fifth finger would make everything freeze. This
behavior is also present without the new patches. Didn't we have ten
fingers working at some point?

Cheers,
Henrik
