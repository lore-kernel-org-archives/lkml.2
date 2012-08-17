Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2HQOjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:39:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34406 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758047Ab2HQOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:38:17 -0400
Date: Fri, 17 Aug 2012 10:38:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
In-Reply-To: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, Ming Lei wrote:

> But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
> further after kernel init is completed?  Or even devices should be allowed
> to add into system?

Indeed, does it make any sense to have USB support at all if HOTPLUG
isn't enabled?  Should USB select HOTPLUG?

Alan Stern

