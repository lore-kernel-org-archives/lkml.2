Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0IDSHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 14:07:47 -0400
Received: from tex.lwn.net ([70.33.254.29]:43373 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0IDSHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:07:46 -0400
Date: Sat, 4 Sep 2010 12:07:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Pavel Roskin <proski@gnu.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: revert some checks added by commit 32aad86f
Message-ID: <20100904120744.3876e539@bike.lwn.net>
In-Reply-To: <20100902184634.18566.78849.stgit@mj.roinet.com>
References: <20100902184634.18566.78849.stgit@mj.roinet.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 14:46:34 -0400
Pavel Roskin <proski@gnu.org> wrote:

> This fixes blur-like screen corruption on the following card:
> 
> VGA compatible controller [0300]: Intel Corporation 82G33/G31 Express
> Integrated Graphics Controller [8086:29c2] (rev 10)

Now that I'm back on the same continent as my desktop system, I can
verify that it fixes things there too.  That makes me happy - thanks!

jon
