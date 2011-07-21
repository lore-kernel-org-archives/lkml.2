Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1GUL7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 07:59:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1GUL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 07:59:43 -0400
Date: Thu, 21 Jul 2011 13:59:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Don Prince <dhprince.devel@yahoo.co.uk>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: prodikeys: make needlessly global symbols static
In-Reply-To: <1311232893.10976.1.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1107211359300.7300@pobox.suse.cz>
References: <1311232893.10976.1.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011, Axel Lin wrote:

> The following symbols are not referenced outside this file so
> there's no need for it to be in the global name space.
> 
>   pcmidi_sustained_note_release
>   init_sustain_timers
>   stop_sustain_timers
>   pcmidi_handle_report
>   pcmidi_setup_extra_keys
>   pcmidi_snd_initialise
>   pcmidi_snd_terminate
> 
> Make them static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
