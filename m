Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1BGOdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:33:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1BGOdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:33:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>, mtk.manpages@gmail.com
Subject: Re: [PATCH] Export linux/syslog.h
Date: Mon, 7 Feb 2011 15:33:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1297079503.1741.10.camel@t41.thuisdomein> <201102071355.55978.arnd@arndb.de> <1297084682.1741.17.camel@t41.thuisdomein>
In-Reply-To: <1297084682.1741.17.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071533.37755.arnd@arndb.de>
X-Provags-ID: V02:K0:oOeqhNJ6Gg+kYg7Uv2qNYWnR+3IiDH4QI7NiQY9Eq8N
 ZQ7G9B/0sV0JTyv5eeErjzxKqsZn7e41sz6pWgFnyTq1h3Gnzg
 F/qsyjV6rs9MsI2bh7mSwjDDZ3YHq9QWvsen3z9UgQo5chAJ7f
 G40B/xc3esl29IKaK8B9a4aZxG3gsohHMhmlcgCPV17x7bFwBJ
 JmKvXH0ESwGDaI8mQY6rw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 February 2011, Paul Bolle wrote:
> > Further, the man page currently documents the raw numbers and should
> > be changed as well with the new constants.
> 
> Yes, I realized that. I assumed that updating the man page should be
> done after this patch was accepted. Or should patches like this one be
> done in parallel with the patch(es) to the relevant man page(s)? Either
> way is fine with me.

I would recommend sending both patches together for review, though the
man page change will not be in a release before the kernel gets released
with your patch.

	Arnd
