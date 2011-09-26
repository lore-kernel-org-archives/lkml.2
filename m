Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1IZNRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:17:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44830 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1IZNRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:17:14 -0400
Subject: Re: [PATCHv7] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Mon, 26 Sep 2011 16:20:04 +0300
In-Reply-To: <1317040680-6199-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1317040680-6199-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317043212.9442.8.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 14:38 +0200, David Wagner wrote:
> 	* "volume" parameter: pass the volume name instead of the volume ID

Sorry if I was not clear, but it should accept both name and number.
Take a look at UBI - it first checks if the string is a number, if yes -
tries to open by number, if this fails, tries to treat this as a name
and open by name.

And AFAICS, you did not change the documentation for the "volume" module
parameter.


-- 
Best Regards,
Artem Bityutskiy

