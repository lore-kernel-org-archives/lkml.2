Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1GSQd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:33:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:38556 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1GSQd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,229,1309762800"; 
   d="scan'208";a="29016208"
Date: Tue, 19 Jul 2011 17:35:02 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] TTY: remove tty_locked
Message-ID: <20110719173502.26fb2d55@bob.linux.org.uk>
In-Reply-To: <1310646915-3032-5-git-send-email-jslaby@suse.cz>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
	<1310646915-3032-5-git-send-email-jslaby@suse.cz>
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

On Thu, 14 Jul 2011 14:35:14 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> We used it really only serial and ami_serial. The rest of the
> callsites were BUG/WARN_ONs to check if BTM is held. Now that we
> pruned tty_locked from both of the real users, we can get rid of
> tty_lock along with __big_tty_mutex_owner.

All looks sensible to me for this series

(the uart wakeup one isn't new and its a different battle to fight)
