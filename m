Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2FXDGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 23:06:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59586 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753432Ab2FXDGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 23:06:47 -0400
Message-ID: <1340507206.7758.30.camel@joe2Laptop>
Subject: Re: [PATCH 5/5] thinkpad_acpi: Convert dbg_printk to tp_dbg and
 tp_vdbg
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 23 Jun 2012 20:06:46 -0700
In-Reply-To: <20120624004051.GC20885@khazad-dum.debian.net>
References: <cover.1339985626.git.joe@perches.com>
	 <d8ab2f07efe50ddd9d3db8612c1cc333cb7e5813.1339985627.git.joe@perches.com>
	 <20120624004051.GC20885@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 21:40 -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 17 Jun 2012, Joe Perches wrote:
> > Use a more current logging style.
> > 
> > Add #define DEBUG and use pr_debug to enable dynamic debugging.
> > Coalesce formats and align arguments.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Joe, are there any extra procedures required from the user to get the debug
> messages with this patch applied?

No.

The added #define DEBUG makes dynamic_debug emit those
messages automatically.  Without the #define DEBUG, then
these tp_[v]dbg calls might not be compiled in at all.

These to_[v]dbg calls can be turned off via the normal
dyn_debug mechanisms.

see: Documentation/dynamic-debug-howto.txt

cheers, Joe

