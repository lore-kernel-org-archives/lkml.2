Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1JPS1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:27:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48687 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab1JPS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:27:03 -0400
Date: Sun, 16 Oct 2011 11:28:15 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        stable@kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] TTY: drop driver reference in tty_open fail path
Message-ID: <20111016182815.GA14883@us.ibm.com>
References: <4E8C6836.1090601@suse.cz>
 <1318411965-23917-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318411965-23917-1-git-send-email-jslaby@suse.cz>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11101618-3270-0000-0000-000000EA522E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby [jslaby@suse.cz] wrote:
| When tty_driver_lookup_tty fails in tty_open, we forget to drop a
| reference to the tty driver. This was added by commit 4a2b5fddd5 (Move
| tty lookup/reopen to caller).
| 
| Fix that by adding tty_driver_kref_put to the fail path.

Arg. Sorry about that. Thanks for spotting/fixing it.

| 
| I will refactor the code later. This is for the ease of backporting to
| stable.
| 
| Introduced-in: v2.6.28-rc2
| Signed-off-by: Jiri Slaby <jslaby@suse.cz>
| Cc: stable@kernel.org
| Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
| Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

