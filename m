Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0KUE2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 23:28:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0KUE2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 23:28:23 -0500
Date: Sat, 20 Nov 2010 23:28:20 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <gregkh@suse.de>
Subject: Re: WARNING: at tty_io.c: line 1331
Message-ID: <20101121042820.GP22651@bombadil.infradead.org>
References: <4CE82F40.3060807@oracle.com>
 <4CE87041.9070704@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE87041.9070704@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 05:05:05PM -0800, Randy Dunlap wrote:
> [oops, first posting was too large for lkml, so instead of attachments,
> I'll put the relevant files online]
> 

Ah, I'm glad someone else hit this. I've been seeing it on Fedora
rawhide recently, but hadn't yet had a chance to figure out if it was my
fault (or cgroups or systemd related, since some reporters have claimed
it was caused by upgrading to it.)

regards, Kyle
