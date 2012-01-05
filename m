Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2AEPm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:42:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab2AEPm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:42:28 -0500
Date: Thu, 5 Jan 2012 06:57:53 -0800
From: Greg KH <gregkh@suse.de>
To: leonid.moiseichuk@nokia.com
Cc: penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        aarcange@redhat.com, riel@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, rebecca@android.com,
        san@google.com, akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Message-ID: <20120105145753.GA3937@suse.de>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB9826904554391@008-AM1MPN1-003.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904554391@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Jan 05, 2012 at 01:02:23PM +0000, leonid.moiseichuk@nokia.com wrote:
> Well, mm/notify.c seems a bit global for me. At the first step I
> handle inputs from Greg and try to find less destructive approach to
> allocation tracking rather than page_alloc.

No, please listen to what people, including me, are saying, otherwise
your code will be totally ignored.

greg k-h
