Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2C1TeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:34:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64342 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab2C1TeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:34:10 -0400
Message-ID: <4F7367AE.4020002@suse.cz>
Date: Wed, 28 Mar 2012 21:34:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@linux.intel.com>,
        Andrea Shepard <andrea@persephoneslair.org>
Subject: Re: [PATCH 1/1] NET: pc300, move to staging as it is broken
References: <1332962915-18146-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1332962915-18146-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 09:28 PM, Jiri Slaby wrote:
> It was marked as BROKEN back in 2008. It is because the tty handling
> in the driver is really broken.
> 
> And since nobody stepped in and rewrote the driver, it is time to move
> it out of line now. And drop it some time later if nobody comes up
> with patches to fix the driver.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

NACK.

I've just found some recent activity in respect to fix this driver which
didn't reach my radar before.

Andrea, what's the status of the patchset?

sorry for the noise,

-- js suse labs

