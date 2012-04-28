Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2D1Qzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:55:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41764 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab2D1Qzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:55:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 28 Apr 2012 18:55:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Burning multiple DVDs at one time
Message-ID: <20120428185503.5a3087c7@stein>
In-Reply-To: <20120428160226.GA9811@animx.eu.org>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
	<20120317142255.GB26403@animx.eu.org>
	<20120317162853.13afa28b@stein>
	<20120318133059.GB10172@animx.eu.org>
	<20120318150127.5f8db40c@stein>
	<20120428160226.GA9811@animx.eu.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 28 Wakko Warner wrote:
> Stefan Richter wrote:
> > On Mar 18 Wakko Warner wrote:
[sr_mutex removal]
> > > Seems to have fixed my problem.
> > 
> > Very nice; so there is an almost easy fix.  Now I or somebody else need to
> > work out the required cdrom_device_info protection on which Arnd and James
> > commented.
> 
> Has anything come of this as far as the fix going into the kernel?

I haven't been working on it in the meantime; don't know if anybode else
did.
-- 
Stefan Richter
-=====-===-- -=-- ===--
http://arcgraph.de/sr/
