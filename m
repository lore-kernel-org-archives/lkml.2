Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1BGWLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:11:45 -0500
Received: from 1wt.eu ([62.212.114.60]:60422 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1BGWLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:11:44 -0500
Date: Mon, 7 Feb 2011 23:11:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@ozlabs.org,
        Amit Shah <amit.shah@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 21/23] hvc_console: Fix race between hvc_close and hvc_remove
Message-ID: <20110207221106.GA10317@1wt.eu>
References: <4beed4da27f06efb2c13d6ed48850634@local> <20110206232253.421321729@pcw.home.local> <20110208081600.1a816af5@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208081600.1a816af5@kryten>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Tue, Feb 08, 2011 at 08:16:00AM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> > From: Amit Shah <amit.shah@redhat.com>
> > 
> > commit e74d098c66543d0731de62eb747ccd5b636a6f4c upstream.
> > 
> > Alan pointed out a race in the code where hvc_remove is invoked. The
> > recent virtio_console work is the first user of hvc_remove().
> 
> I faintly remember this bug caused boot issues and the following patch
> must be applied to fix it.

The patch you pointed was indeed merged just after this one so we should
be OK. Thanks very much for the double check !

Willy

