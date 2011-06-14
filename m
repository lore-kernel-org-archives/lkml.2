Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1FNN0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:26:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:20255 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1FNN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:26:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,364,1304319600"; 
   d="scan'208";a="14418656"
Date: Tue, 14 Jun 2011 14:24:46 +0100
From: Alan Cox <alan@linux.intel.com>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Andreas Koensgen <ajk@comnets.uni-bremen.de>,
        Samuel Ortiz <samuel@sortiz.org>, Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Pavan Savoy <pavan_savoy@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tobias Klauser <tklauser@distanz.ch>, Jiri Slaby <jslaby@suse.cz>,
        linux-bluetooth@vger.kernel.org, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] TTY: define TTY_MAX_RECEIVE_ROOM to 65536
Message-ID: <20110614142446.063c0859@bob.linux.org.uk>
In-Reply-To: <1308057986-11472-1-git-send-email-ffainelli@freebox.fr>
References: <1308057986-11472-1-git-send-email-ffainelli@freebox.fr>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 15:26:25 +0200
Florian Fainelli <ffainelli@freebox.fr> wrote:

> A lot of TTY drivers are setting their receive_room value to 65536
> so let's define a constant for this.

These are not all the same thing so NAK

Linus wants to get rid of tty->receive_room anyway

