Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1HJSH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:07:58 -0400
Received: from dd13538.kasserver.com ([85.13.135.107]:36941 "EHLO
	dd13538.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HJSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:07:57 -0400
Date: Wed, 10 Aug 2011 20:07:54 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
Message-ID: <20110810180754.GB13832@bombe-desk.opditex>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de,
	linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
 <20110719003503.GA4138@amos.fritz.box>
 <4E3FE2D2.5020801@gmail.com>
 <20110810010933.GA4733@amos.fritz.box>
 <4E429907.6080000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E429907.6080000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:43:19PM +0200, Jiri Slaby wrote:
> On 08/10/2011 03:09 AM, Andreas Bombe wrote:
> > I did my simple test on ttyS0 again: "stty -F /dev/ttyS0 crtscts" then
> > "echo >/dev/ttyS0". I attached the gzipped sysrq-t list in case you need
> > the complete output. This is just the process while it is trying to
> > close the device (bash's internal echo):
> 
> Hmm, perhaps obvious question. What is the port connected with? And with
> what cable? Is it null modem cable? Or at least with DTR-CTS connected?

Nothing is connected. After all, the whole point of this exercise is to
give the driver data to send which it can't get out so I can see whether
it blocks all tty operations system wide while trying to do the flush on
close.

-- 
Andreas Bombe
