Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab1D0XPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:15:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760166Ab1D0XP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:15:29 -0400
Date: Wed, 27 Apr 2011 16:14:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Peter Foley <pefoley2@verizon.net>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
Message-Id: <20110427161451.26a74fec.akpm@linux-foundation.org>
In-Reply-To: <20110426130036.997a05fc.rdunlap@xenotime.net>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 13:00:36 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> is forced to stay as one unit.  Hopefully this will help to prevent
> it being broken in the future.

With this patch applied, a `make oldconfig' unsets CONFIG_PRINTK,
producing a less-than-previously-useful kernel!

Config: http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt
