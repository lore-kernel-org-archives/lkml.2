Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab0JQP6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:58:15 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45324 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0JQP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:58:13 -0400
Date: Sun, 17 Oct 2010 08:58:09 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Random compiler errors
Message-ID: <20101017085809.00e07cbd@s6510>
In-Reply-To: <20101016190416.bdbfc69f.rdunlap@xenotime.net>
References: <20101016174854.4b8eec07@s6510>
	<20101016190416.bdbfc69f.rdunlap@xenotime.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 19:04:16 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Sat, 16 Oct 2010 17:48:54 -0700 Stephen Hemminger wrote:
> 
> > Not sure why this is happening, but lately when building kernels
> > I am getting non-reproducible cases of gcc failure. There are no
> > messages in system log. Cosmic rays? Bad memory?
> 
> I haven't had these personally, but from reading lkml over the past
> N years, these are usually due to memory or disk/storage problems.

That was what I thought, but memtest comes up clean and the
storage is SSD. My suspicion is something like EDAC or some DMA
bug.
