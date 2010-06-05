Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab0FEXpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:45:11 -0400
Received: from solo.fdn.fr ([80.67.169.19]:55754 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775Ab0FEXpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:45:09 -0400
Date: Sun, 6 Jun 2010 01:45:06 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] LEDS: leds-input, fix sleep inside atomic
Message-ID: <20100605234505.GZ5358@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jiri Slaby <jslaby@suse.cz>, rpurdie@rpsys.net,
	akpm@linux-foundation.org, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <1275772342-25094-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275772342-25094-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby, le Sat 05 Jun 2010 23:12:22 +0200, a écrit :
> Fix this by changing the spinlock to mutex as it is used only in
> input_handler->connect and ->disconnect and it is safe to sleep
> there.

Right. in a previous patch it was also used in interrupt context, but
now it should be safe indeed.

Andrew, please fold it into the leds-input patch.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

BTW, please also Cc authors of files when reporting bugs... :)

Samuel
