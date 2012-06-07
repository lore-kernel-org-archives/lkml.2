Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2FGJEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:04:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:34898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760194Ab2FGJEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154116250"
Date: Thu, 7 Jun 2012 10:19:51 +0100
From: Alan Cox <alan@linux.intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jslaby@suse.cz,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: um: TTY fixes (?)
Message-ID: <20120607101951.14d6596d@bob.linux.org.uk>
In-Reply-To: <4FCFE504.2020100@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<20120604221731.5e378fc2@pyramind.ukuu.org.uk>
	<4FCFE504.2020100@nod.at>
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

On Thu, 07 Jun 2012 01:17:24 +0200
Richard Weinberger <richard@nod.at> wrote:

> Am 04.06.2012 23:17, schrieb Alan Cox:
> > We can half ignore it on console for the simple reason that you
> > don't "dial in" to the console. I suspect it may be abusable but
> > I've not found a way to do so.
> > 
> 
> BTW: Can't we add such a mode to tty_port?
> E.g. tty_port->non_dialin_console. 8)

That is basically what you are doing when you omit a hangup method. The
security consequences on a multi-user box run deeper however so in the
end we need to fix the util-linux code.

Alan
