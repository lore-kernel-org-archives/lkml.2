Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1D1Cgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:36:55 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48244 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751836Ab1D1Cgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:36:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=vPBWX4gsttAuVdo4LXp5JScn8zv9X1gRir+UcL0z1YrFL0s/ZbKed/yOkDM1vujuGCcXLjgyawsmbIury/uIpnC3NRAC5IJ1lQ9WRo9T2U18h0M/irRFqZdPDb9nvNTx;
Date: Wed, 27 Apr 2011 19:36:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Peter Foley <pefoley2@verizon.net>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
Message-Id: <20110427193651.1d279d29.rdunlap@xenotime.net>
In-Reply-To: <20110427161451.26a74fec.akpm@linux-foundation.org>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
	<20110427161451.26a74fec.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 16:14:51 -0700 Andrew Morton wrote:

> On Tue, 26 Apr 2011 13:00:36 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> > is forced to stay as one unit.  Hopefully this will help to prevent
> > it being broken in the future.
> 
> With this patch applied, a `make oldconfig' unsets CONFIG_PRINTK,
> producing a less-than-previously-useful kernel!
> 
> Config: http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt

Yep, that's a problem.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
