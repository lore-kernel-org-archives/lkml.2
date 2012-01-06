Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2AFBSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:18:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61052 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab2AFBS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:18:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120105223933.GA10268@kroah.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
	<20120105223933.GA10268@kroah.com>
Date: Thu, 5 Jan 2012 23:18:28 -0200
Message-ID: <CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
From: Fabio Estevam <festevam@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 8:39 PM, Greg KH <greg@kroah.com> wrote:

> Are you sure that this isn't getting confused with the
> drivers/char/misc.c interface instead of the "throw a bunch of randome
> drivers into drivers/misc/" issue?

Sorry, I am not aware of this issue.

> Why would anything ever want to select MISC_DEVICES?  What happens if
> you just remove that select line from the Kconfig?

Yes, I don´t understand the point of allowing the selection MISC_DEVICES.

IMHO it is potential for causing dependency issues.

Thanks,

Fabio Estevam
