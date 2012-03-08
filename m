Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2CHNQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:16:48 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47400 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2CHNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:16:46 -0500
Date: Thu, 8 Mar 2012 15:16:40 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Richard Weinberger <rw@linutronix.de>, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
Message-ID: <20120308151640.0a7aa240@halley>
In-Reply-To: <1331207881.7257.37.camel@sauron.fi.intel.com>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	<1331138007.3463.16.camel@sauron.fi.intel.com>
	<4F57D0C4.1050605@linutronix.de>
	<20120308090835.032fe13a@pixies.home.jungo.com>
	<4F587A28.6080205@linutronix.de>
	<1331207881.7257.37.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 13:58:01 +0200 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> To write the ubibis and to ubibis? Hmm... not sure.
> 
> To write the fastmap and to fastmap or decide to not fastmap because all
> PEBs within the first 64 have too high erasecounter? Sounds better IMO.

FWIW, fastmap sounds reasonable to me.

(aside from the fact that "fast" is the outcome of using the map,
whereas the map's definition is essentially a peb/leb map).

Anyways,

CONFIG_MTD_UBI_FASTMAP, ubi_find_fastmap(), ubi_scan_fastmap(),
ubi_read_fastmap(), ubi_update_fastmap() ...

all seem pretty explanatory IMO.

Using plain "map" (ubi_find_map, ubi_update_map) might also be an
option, however it might be less obvious.

Regards,
Shmulik
