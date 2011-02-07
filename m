Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1BGNSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:18:05 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:51822 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1BGNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:18:04 -0500
Subject: Re: [PATCH] Export linux/syslog.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 07 Feb 2011 14:17:58 +0100
In-Reply-To: <201102071355.55978.arnd@arndb.de>
References: <1297079503.1741.10.camel@t41.thuisdomein>
	 <201102071355.55978.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297084682.1741.17.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 13:55 +0100, Arnd Bergmann wrote:
> The comment in the header file currently starts with "Syslog internals".
> If you want to export it, you should probably change that, too.

That makes sense.

> Further, the man page currently documents the raw numbers and should
> be changed as well with the new constants.

Yes, I realized that. I assumed that updating the man page should be
done after this patch was accepted. Or should patches like this one be
done in parallel with the patch(es) to the relevant man page(s)? Either
way is fine with me.


Paul

