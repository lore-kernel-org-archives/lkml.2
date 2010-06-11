Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab0FKUSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:18:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab0FKUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:18:52 -0400
Date: Fri, 11 Jun 2010 13:17:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 11/12] MAINTAINERS: Remove section WAVELAN NETWORK
 DRIVER & WIRELESS EXTENSIONS
Message-Id: <20100611131750.6c62691a.akpm@linux-foundation.org>
In-Reply-To: <0f7d3ebb9e9e01b87c00fc3061861f2172ea790d.1276112118.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
	<0f7d3ebb9e9e01b87c00fc3061861f2172ea790d.1276112118.git.joe@perches.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jun 2010 12:38:37 -0700
Joe Perches <joe@perches.com> wrote:

> commit 1d794e3b353b50ab5d9d46f7c15607f9ec8c78e0 removed it

grump.

Sentences start with capital letters and end with full-stops.

The preferred way of referring to a commit ID is

	1d794e3b353b50ab5d9d46f7c15607f9ec8c78e0 ("Staging: wavelan: delete the driver").

or

	1d794e3b353b ("Staging: wavelan: delete the driver").

Yes, it's a pita entering that in there, but I'd rather it be your pita
than my pita ;)

If someone can come up with a checkpatch rule which detects a git hash
not followed by ("text"), that would help.


Alternatively, we beat Linus up and just use bare commit ID's.  All
commit IDs refer to Linus's tree anwyay, so if someone wants to locate
a commit within a different tree, they look up the patch title in
Linus's tree first.

Except for when people send commit ID's which just don't exist in
Linus's tree, which happens occasionally.
