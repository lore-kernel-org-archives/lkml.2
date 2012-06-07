Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2FGQep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:34:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:59624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab2FGQeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162345010"
Date: Thu, 7 Jun 2012 17:50:24 +0100
From: Alan Cox <alan@linux.intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Boaz Harrosh <bharrosh@panasas.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jslaby@suse.cz
Subject: Re: [uml-devel] um: TTY fixes (?)
Message-ID: <20120607175024.696be664@bob.linux.org.uk>
In-Reply-To: <4FD0D7AA.4010506@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<4FCF6748.6020005@panasas.com>
	<4FD059AC.8050808@panasas.com>
	<4FD06A22.6040002@nod.at>
	<4FD07F14.50902@panasas.com>
	<4FD0802A.1020203@nod.at>
	<20120607115227.6643d1ad@pyramind.ukuu.org.uk>
	<4FD0C64D.2050302@nod.at>
	<20120607173711.22ae146f@bob.linux.org.uk>
	<4FD0D7AA.4010506@nod.at>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2012 18:32:42 +0200
Richard Weinberger <richard@nod.at> wrote:

> Am 07.06.2012 18:37, schrieb Alan Cox:
> > Yes I know exactly what is going on. However getting a more tolerant
> > behaviour is going to take a couple more kernels.
> > 
> 
> So, then please tell me what's the proper way to fix the UML console
> driver?
> 
> - tty_port plus ->hangup() works only with a patched util-linux
> - tty_port without ->hangup() seems to work only if *getty does not
> call vhangup()

There isn't a nice one. It'll have to wait until 3.6/7 or so to get
fixed nicely and it won't backport either.

Alan
