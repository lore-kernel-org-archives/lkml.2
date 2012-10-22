Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2JVQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:17:16 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:46512 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2JVQRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:17:14 -0400
From: Nix <nix@esperi.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Bryan Schumaker <bjschuma@netapp.com>, Peng Tao <bergwolf@gmail.com>,
        Trond.Myklebust@netapp.com, gregkh@linuxfoundation.org
Subject: Heads-up: 3.6.2 / 3.6.3 NFS server panic: 3.6.2+ regression?
Emacs: Lovecraft was an optimist.
Date: Mon, 22 Oct 2012 17:17:04 +0100
Message-ID: <87objupjlr.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a panic/oops on upgrading from 3.6.1 to 3.6.3, after weeks of
smooth operation on 3.6.1: one of the NFS changes that went into one of
the two latest stable kernels appears to be lethal after around half an
hour of uptime. The oops came from NFSv4, IIRC (relying on memory since
my camera was recharging and there is no netconsole from that box
because it is where the netconsole logs go, so I'll have to reproduce it
later today). The machine is an NFSv3 server only at present, with no
NFSv4 running (though NFSv4 is built in).

This is just a heads-up, not intended to be sufficient to track it down
unless it is instantly obvious: more later, including a .config dump and
proper oops report if it turns out to be reproducible. I just have to
recover from the usual panic-induced fs corruption and take a backup
first.

-- 
NULL && (void)
