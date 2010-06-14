Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0FNSvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:51:46 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:44420 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0FNSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=khv9k/ZAb0wErBxsC+OAOxGM5MfEfSaldreF6FK7duHUMZK6uRBiWK+afcbhQKlTng
         XdJs11SzWD+d9v5xKPvSrv3h/3gSfIHPDmqB+/VQKYvvXEP1ux4IbxRf+pQerrjQM8n3
         AXPqe3vd0cB2pq2mjnRcI+iALExNlFrr4G/OY=
MIME-Version: 1.0
In-Reply-To: <20100614162002.GA13902@kroah.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
	<20100614162002.GA13902@kroah.com>
Date: Tue, 15 Jun 2010 02:44:36 +0800
Message-ID: <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on 
	Linux-2.6.xx
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:20 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 14, 2010 at 11:16:29PM +0800, Jeff Chua wrote:


> This is a warning that you can ignore, it's been fixed in the latest
> tree (2.6.35-rc3).
>
> try that and see.

Greg,

Ok, just tried rc3 and it's fixed the 1st OOPS.

But I'm still seeing the "ataX" incrementing from ata7 to ata8, ata9
... after taking out and putting back the card. It seems the interface
is still not shutting down properly. ... Any command to shutdown it
down gracefully?

ata9.00: disabled
2010-06-15T02:32:04.531177+08:00 boston kernel: ata9.00: disabled
sd 8:0:0:0: [sdb] Synchronizing SCSI cache
sd 8:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
sd 8:0:0:0: [sdb] Stopping disk
sd 8:0:0:0: [sdb] START_STOP FAILED
sd 8:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
2010-06-15T02:32:04.568687+08:00 boston kernel: sd 8:0:0:0: [sdb]
Synchronizing SCSI cache
2010-06-15T02:32:04.568715+08:00 boston kernel: sd 8:0:0:0: [sdb]
Result: hostbyte=0x04 driverbyte=0x00
2010-06-15T02:32:04.568719+08:00 boston kernel: sd 8:0:0:0: [sdb] Stopping disk
2010-06-15T02:32:04.568731+08:00 boston kernel: sd 8:0:0:0: [sdb]
START_STOP FAILED
2010-06-15T02:32:04.568735+08:00 boston kernel: sd 8:0:0:0: [sdb]
Result: hostbyte=0x04 driverbyte=0x00
ata9: failed to stop engine (-5)
ahci 0000:05:00.0: PCI INT A disabled
2010-06-15T02:32:05.068765+08:00 boston kernel: ata9: failed to stop engine (-5)
2010-06-15T02:32:05.068797+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A disabled



Thanks,
Jeff
